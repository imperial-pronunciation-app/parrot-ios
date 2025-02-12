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
    var returnValues: [String : [Any?]] = [:]
    
    
    func login(username: String, password: String) async throws {
        let funcName = "login"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [username, password])
    }
    
    func logout() async throws {
        let funcName = "logout"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [])
    }
    
    func register(email: String, password: String) async throws {
        let funcName = "register"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [email, password])
    }
    
    func saveTokens(accessToken: String) throws {
        let funcName = "saveTokens"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [accessToken])
    }
    
    func getAccessToken() -> String? {
        let funcName = "getAccessToken"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
}
