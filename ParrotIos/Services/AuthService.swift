//
//  AuthService.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private let baseURL = "https://pronunciation-app-backend.doc.ic.ac.uk"
    
    private init() {}

    func login(email: String, password: String) async -> AuthResponse? {
        let formBody = "username=\(email)&password=\(password)"
        guard let formData = formBody.data(using: .utf8) else { return nil }
        
        guard let url = URL(string: "\(baseURL)/auth/jwt/login") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Login failed with status: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return nil
            }
            
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            saveTokens(accessToken: authResponse.accessToken, refreshToken: authResponse.refreshToken)
            return authResponse
        } catch {
            print("Error during login: \(error)")
            return nil
        }
    }
    
    func logout() async -> Bool {
        guard let accessToken = getAccessToken() else { return false }
        guard let url = URL(string: "\(baseURL)/auth/jwt/logout") else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Logout failed with status: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return false
            }
            
            clearTokens()  // Clear tokens from local storage
            return true
        } catch {
            print("Error during logout: \(error)")
            return false
        }
    }

    func register(email: String, password: String) async -> AuthResponse? {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            // TODO: include the optional fields such as super_user?
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to encode registration data.")
            return nil
        }
        
        guard let url = URL(string: "\(baseURL)/users/register") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                print("Registration failed with status: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return nil
            }
            
            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
            saveTokens(accessToken: authResponse.accessToken, refreshToken: authResponse.refreshToken)
            return authResponse
        } catch {
            print("Error during registration: \(error)")
            return nil
        }
    }

    func saveTokens(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
}
