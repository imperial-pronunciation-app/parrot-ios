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
    class LoginViewModel {
        private(set) var isAuthenticated = false
        private(set) var errorMessage: String?
        
        private let authService = AuthService()
        
        func login(username: String, password: String) async {
            do {
                try await authService.login(username: username, password: password)
//                self.errorMessage = "Login successfully"
            } catch LoginError.badCredentials {
                self.errorMessage = "Incorrect username or password."
            } catch LoginError.userNotVerified {
                self.errorMessage = "User not verified."
            } catch {
                self.errorMessage = "Unknown error occurred."
            }
        }
        
        func logout() async {
            do {
                try await authService.logout()
//                self.errorMessage = "Logout successfully"
            } catch LogoutError.notLoggedIn {
                self.errorMessage = "User not logged in."
            } catch LogoutError.customError(let error) {
                self.errorMessage = error
            } catch {
                self.errorMessage = "Error when logging out: \(error.localizedDescription)"
            }
        }
    }
}
