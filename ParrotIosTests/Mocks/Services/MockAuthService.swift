//
//  MockAuthService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

@testable import ParrotIos

class MockAuthService: AuthServiceProtocol, CallTracking {
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Result<Any?, Error>]] = [:]
    
    
    func login(username: String, password: String) async throws {
        recordCall(for: "login", with: [username, password])
    }
    
    func logout() async throws {
        recordCall(for: "logout")
    }
    
    func register(email: String, password: String) async throws {
        recordCall(for: "register", with: [email, password])
    }
    
    func saveTokens(accessToken: String) throws {
        recordCall(for: "saveTokens", with: [accessToken])
    }
    
    func getAccessToken() -> String? {
        let method = "getAccessToken"
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
}
