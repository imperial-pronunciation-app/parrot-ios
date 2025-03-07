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
    static let getUserDetails = "getUserDetails"
    static let logout = "logout"
    static let register = "register"
    static let saveTokens = "saveTokens"
    static let getAccessToken = "getAccessToken"
    static let updateDetails = "updateDetails"
}

class MockAuthService: AuthServiceProtocol, CallTracking {
    var callCounts: [String: Int] = [:]
    var callArguments: [String: [[Any?]]] = [:]
    var returnValues: [String: [Result<Any?, Error>]] = [:]

    func login(email: String, password: String) async throws {
        recordCall(for: AuthServiceMethods.login, with: [email, password])
    }

    func getUserDetails() async throws {
        recordCall(for: AuthServiceMethods.getUserDetails)
    }

    func logout() async throws {
        recordCall(for: AuthServiceMethods.logout)
    }

    func register(email: String, displayName: String, password: String) async throws {
        recordCall(for: AuthServiceMethods.register, with: [email, displayName, password])
    }

    func updateDetails(name: String, email: String, language: Int) async throws {
        recordCall(for: AuthServiceMethods.updateDetails, with: [name, email, language])
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

    var userDetails: UserDetails? = UserDetails(id: 1, loginStreak: 1, xpTotal: 1, email: "test@example.com", displayName: "Test", language: Language(id: 1, code: "eng", name: "English"), league: "Bronze", avatar: "BLUE")

}
