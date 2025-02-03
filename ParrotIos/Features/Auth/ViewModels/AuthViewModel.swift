//
//  AuthViewModel.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    private let authService = AuthService.shared
    
    func login(email: String, password: String) async {
        if let response = await authService.login(email: email, password: password) {
            authService.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Login failed. Please check your credentials."
            }
        }
    }
    
    func logout() async {
        if await authService.logout() {
            authService.clearTokens()
            DispatchQueue.main.async {
                self.isAuthenticated = false
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Logout failed. Please try again."
            }
        }
    }
}
