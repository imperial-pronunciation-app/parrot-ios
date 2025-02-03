//
//  AuthService.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import Foundation

class AuthService {
    private let webService = WebService()
    private let baseURL = "https://pronunciation-app-backend.doc.ic.ac.uk"
    
    enum AuthServiceError: Error {
        case customError(String)
    }
    
    func login(username: String, password: String) async -> Result<AuthResponse, AuthServiceError> {
        let parameters = [
            FormDataURLEncodedElement(key: "grant_type", value: "authorization_code"),
            FormDataURLEncodedElement(key: "username", value: username),
            FormDataURLEncodedElement(key: "password", value: password)
        ]
        
        do {
            let response: AuthResponse = try await webService.postURLEncodedFormData(parameters: parameters, toURL: "\(baseURL)/auth/jwt/login")
            saveTokens(accessToken: response.access_token)
            return .success(response)
        } catch NetworkError.badStatus {
            return .failure(.customError("Error during login: server returned bad status code."))
        } catch {
            return .failure(.customError("Error during login: \(error.localizedDescription)"))
        }
    }
    
    func logout() async -> Result<AuthResponse, AuthServiceError> {
        guard let accessToken = getAccessToken() else { return .failure(.customError("Error during logout: No access token.")) }
        let authHeaders = [HeaderElement(key: "Authorization", value: "Bearer " + accessToken)]
        
        do {
            let response: AuthResponse = try await webService.post(toURL: "\(baseURL)/auth/jwt/logout", headers: authHeaders)
            return .success(response)
        } catch {
            return .failure(.customError("Error during logout: \(error.localizedDescription)"))
        }
    }

    func register(email: String, password: String) async -> Result<AuthResponse, AuthServiceError> {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            // TODO: include the optional fields such as super_user?
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: body) else { return .failure(.customError("Error in JSON serialization")) }
        
        do {
            let response: AuthResponse = try await webService.postData(data: data, toURL: "\(baseURL)/users/register")
            return .success(response)
        } catch {
            return .failure(.customError("Error during register: \(error)"))
        }
    }

    func saveTokens(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
}
