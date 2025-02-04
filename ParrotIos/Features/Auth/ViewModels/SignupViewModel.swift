//
//  SignupViewModel.swift
//  ParrotIos
//
//  Created by James Watling on 04/02/2025.
//

import Foundation
import Combine

extension SignupView {
    @Observable
    class SignupViewModel {
        private(set) var isAuthenticated = false
        private(set) var errorMessage: String?
        
        private let authService = AuthService()
        
        func register(email: String, password: String) async {
            do {
                try await authService.register(email: email, password: password)
            } catch RegisterError.userAlreadyExists {
                self.errorMessage = "User Already Exists"
            } catch RegisterError.customError(let error) {
                self.errorMessage = error
            } catch {
                self.errorMessage = "Error when registering: \(error.localizedDescription)"
            }
        }

    }
}
