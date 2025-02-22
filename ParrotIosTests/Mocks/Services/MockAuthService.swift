//
//  MockAuthService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

@testable import ParrotIos

struct AuthServiceMethods {
    static let login = "login"
    static let logout = "logout"
    static let register = "register"
    static let saveTokens = "saveTokens"
    static let getAccessToken = "getAccessToken"
}

class MockAuthService: AuthServiceProtocol, CallTracking {
    var callCounts: [String: Int] = [:]
    var callArguments: [String: [[Any?]]] = [:]
    var returnValues: [String: [Result<Any?, Error>]] = [:]

    func login(username: String, password: String) async throws {
        recordCall(for: AuthServiceMethods.login, with: [username, password])
    }

    func logout() async throws {
        recordCall(for: AuthServiceMethods.logout)
    }

    func register(email: String, password: String) async throws {
        recordCall(for: AuthServiceMethods.register, with: [email, password])
    }

    func saveTokens(accessToken: String) throws {
        recordCall(for: AuthServiceMethods.saveTokens, with: [accessToken])
    }

    func getAccessToken() -> String? {
        let method = AuthServiceMethods.getAccessToken
        recordCall(for: method)

        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }

}
