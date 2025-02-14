//
//  AuthService.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import Foundation

final class AuthService: AuthServiceProtocol {
    
    static let instance = AuthService()
    private let webService: WebServiceProtocol
    internal let baseURL = "https://" + (Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String)
    internal var isAuthenticated = false
    
    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }
    
    func login(username: String, password: String) async throws {
        let parameters = [
            FormDataURLEncodedElement(key: "username", value: username),
            FormDataURLEncodedElement(key: "password", value: password)
        ]
        
        do {
            let response: LoginAPIResponse = try await webService.postURLEncodedFormData(parameters: parameters, toURL: "\(baseURL)/auth/jwt/login")
            try saveTokens(accessToken: response.access_token)
            self.isAuthenticated = true
            return
        } catch NetworkError.badStatus(let code, let data) {
            if code != 400 {
                throw LoginError.customError("Error during login: bad status.")
            }
            
            if let data = data {
                guard let decodedResponse = try? JSONDecoder().decode(LoginAPIErrorResponse.self, from: data) else { throw LoginError.customError("Failed to decode error response.") }
                switch decodedResponse.detail {
                case LoginAPIErrorResponseDetail.LOGIN_BAD_CREDENTIALS:
                    throw LoginError.badCredentials
                case LoginAPIErrorResponseDetail.LOGIN_USER_NOT_VERIFIED:
                    throw LoginError.userNotVerified
                }
            } else {
                throw LoginError.customError("Error during login: unknown.")
            }
        } catch {
            throw LoginError.customError("Error during login: \(error.localizedDescription)")
        }
    }
    
    func logout() async throws {
        guard let accessToken = getAccessToken() else { throw LogoutError.notLoggedIn }
        let authHeaders = [HeaderElement(key: "Authorization", value: "Bearer " + accessToken)]
        
        do {
            try await webService.postNoResponse(toURL: "\(baseURL)/auth/jwt/logout", headers: authHeaders)
            self.isAuthenticated = false
        } catch {
            throw LogoutError.customError("Error during logout: \(error.localizedDescription)")
        }
    }

    func register(email: String, password: String) async throws {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            // TODO: include the optional fields such as super_user?
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: body) else { throw RegisterError.customError("Error in JSON serialization") }
        
        do {
            let _: RegisterAPIResponse = try await webService.postData(data: data, toURL: "\(baseURL)/users/register")
            return
        } catch NetworkError.badStatus(let code, let data){
            if code != 400 {
                throw RegisterError.customError("Error during login: bad status.")
            }
            
            if let data = data {
                guard let decodedResponse = try? JSONDecoder().decode(RegisterAPIErrorResponse.self, from: data) else { throw LoginError.customError("Failed to decode error response.") }
                switch decodedResponse.detail {
                case RegisterAPIErrorResponseDetail.REGISTER_USER_ALREADY_EXISTS:
                    throw RegisterError.userAlreadyExists
                }
            } else {
                throw RegisterError.customError("Error during login: unknown.")
            }
        }
    }


    func saveTokens(accessToken: String) throws {
        try KeychainManager.instance.saveToken(accessToken, forKey: "access_token")
    }
    
    func getAccessToken() -> String? {
        return KeychainManager.instance.getToken(forKey: "access_token")
    }
}

struct LoginAPIResponse: Codable {
    let access_token: String
    let token_type: String
}

enum LoginAPIErrorResponseDetail: String, Codable {
    case LOGIN_BAD_CREDENTIALS = "LOGIN_BAD_CREDENTIALS"
    case LOGIN_USER_NOT_VERIFIED = "LOGIN_USER_NOT_VERIFIED"
}

struct LoginAPIErrorResponse: Codable {
    let detail: LoginAPIErrorResponseDetail
}

enum LoginError: Error, Equatable {
    case badCredentials
    case userNotVerified
    case customError(String)
}

enum LogoutError: Error, Equatable {
    case notLoggedIn
    case customError(String)
}

struct RegisterAPIResponse: Codable {
    let id: Int
    let email: String
}

enum RegisterAPIErrorResponseDetail: String, Codable {
    case REGISTER_USER_ALREADY_EXISTS = "REGISTER_USER_ALREADY_EXISTS"
}

struct RegisterAPIErrorResponse: Codable {
    let detail: RegisterAPIErrorResponseDetail
}

enum RegisterError: Error, Equatable {
    case userAlreadyExists
    case customError(String)
}
