//
//  MockAuthService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

class MockAuthService: AuthServiceProtocol, CallTracking {
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Any?]] = [:]
    
    
    func login(username: String, password: String) async throws {
        var funcName = "login"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [username, password])
    }
    
    func logout() async throws {
        var funcName = "logout"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [])
    }
    
    func register(email: String, password: String) async throws {
        var funcName = "register"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [email, password])
    }
    
    func saveTokens(accessToken: String) throws {
        var funcName = "saveTokens"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [accessToken])
    }
    
    func getAccessToken() -> String? {
        var funcName = "getAccessToken"
        incrementCallCount(for: funcName)
        recordCallArguments(for: funcName, arguments: [])
        
        do {
            return try getReturnValue(for: funcName, callIndex: callCounts[funcName]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
}
