//
//  MockAuthService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
    func login(username: String, password: String) async throws {
        fatalError("Mock not implemented")
    }
    
    func logout() async throws {
        fatalError("Mock not implemented")
    }
    
    func register(email: String, password: String) async throws {
        fatalError("Mock not implemented")
    }
    
    func saveTokens(accessToken: String) throws {
        fatalError("Mock not implemented")
    }
    
    func getAccessToken() -> String? {
        fatalError("Mock not implemented")
    }
    
    
}
