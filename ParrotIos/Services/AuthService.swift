//
//  AuthService.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import Foundation

final class AuthService: AuthServiceProtocol, ObservableObject {

    static var instance = AuthService()
    private let webService: WebServiceProtocol
    internal let baseURL = getBaseUrl()
    @Published var isAuthenticated = false
    private(set) var userDetails: UserDetails?

    private init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }

    static func reinit(webService: WebServiceProtocol) {
        self.instance = AuthService(webService: webService)
    }

    func login(username: String, password: String) async throws {
        let parameters = [
            FormDataURLEncodedElement(key: "username", value: username),
            FormDataURLEncodedElement(key: "password", value: password)
        ]

        do {
            let response: LoginAPIResponse = try await webService.postURLEncodedFormData(
                parameters: parameters, toURL: "\(baseURL)/auth/jwt/login")
            try saveTokens(accessToken: response.accessToken)
            await MainActor.run {
                self.isAuthenticated = true
            }
            self.userDetails = try await webService.get(
                fromURL: "\(baseURL)/users/me",
                headers: [generateAuthHeader(accessToken: response.accessToken)]
            )
            return
        } catch NetworkError.badStatus(let code, let data) {
            if code != 400 {
                throw LoginError.customError("Error during login: bad status.")
            }

            if let data = data {
                guard let decodedResponse = try? JSONDecoder().decode(LoginAPIErrorResponse.self, from: data) else {
                    throw LoginError.customError("Failed to decode error response.")
                }
                switch decodedResponse.detail {
                case LoginAPIErrorResponseDetail.loginBadCredentials:
                    throw LoginError.badCredentials
                case LoginAPIErrorResponseDetail.loginUserNotVerified:
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

    func register(email: String, displayName: String, password: String) async throws {
        let body: [String: Any] = [
            "email": email,
            "display_name": displayName,
            "password": password
            // TODO: include the optional fields such as super_user?
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: body) else {
            throw RegisterError.customError("Error in JSON serialization")
        }

        do {
            let _: RegisterAPIResponse = try await webService.postData(data: data, toURL: "\(baseURL)/users/register")
            return
        } catch NetworkError.badStatus(let code, let data) {
            if code != 400 {
                throw RegisterError.customError("Error during login: bad status.")
            }

            if let data = data {
                guard let decodedResponse = try? JSONDecoder().decode(RegisterAPIErrorResponse.self, from: data) else {
                    throw LoginError.customError("Failed to decode error response.")
                }
                switch decodedResponse.detail {
                case RegisterAPIErrorResponseDetail.registerUserAlreadyExists:
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
    let accessToken: String
    let tokenType: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

enum LoginAPIErrorResponseDetail: String, Codable {
    case loginBadCredentials
    case loginUserNotVerified
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
    case registerUserAlreadyExists
}

struct RegisterAPIErrorResponse: Codable {
    let detail: RegisterAPIErrorResponseDetail
}

enum RegisterError: Error, Equatable {
    case userAlreadyExists
    case customError(String)
}

struct UserDetails: Codable {
    let id: Int
    let loginStreak: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case loginStreak = "login_streak"
    }
}
