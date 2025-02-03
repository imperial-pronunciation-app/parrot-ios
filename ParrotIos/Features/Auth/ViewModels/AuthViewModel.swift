//
//  AuthViewModel.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import Foundation
import Combine

extension LoginView {
    @Observable
    class AuthViewModel {
        private(set) var isAuthenticated = false
        private(set) var errorMessage: String?
        
        private let authService = AuthService()
        
        func login(username: String, password: String) async {
            let result = await authService.login(username: username, password: password)
            switch result {
            case .success(let authResponse):
                authService.saveTokens(accessToken: authResponse.access_token)
                self.isAuthenticated = true
            case .failure(let error):
                self.errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
        
        func logout() async {
            let result = await authService.logout()
            switch result {
            case .success:
                authService.clearTokens()
                self.isAuthenticated = false
            case .failure(let error):
                self.errorMessage = "Logout failed: \(error.localizedDescription)"
            }
        }
        
        func register(email: String, password: String) async {
            let result = await authService.register(email: email, password: password)
            switch result {
            case .success(let authResponse):
                authService.saveTokens(accessToken: authResponse.access_token)
                self.isAuthenticated = true
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
