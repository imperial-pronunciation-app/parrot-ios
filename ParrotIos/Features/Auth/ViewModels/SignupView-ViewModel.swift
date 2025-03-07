//
//  SignupViewModel.swift
//  ParrotIos
//
//  Created by James Watling on 04/02/2025.
//

import Foundation
import Combine
import SwiftUI

extension SignupView {
    @Observable
    class ViewModel {
        private(set) var isAuthenticated = false
        private(set) var errorMessage: String?

        private let authService = AuthService.instance

        func register(
            email: String,
            displayName: String,
            password: String,
            confirmPassword: String,
            succeed: Binding<Bool>
        ) async {
            if password != confirmPassword {
                self.errorMessage = "Password and confirmation do not match."
                return
            }
            if email == "" || displayName == "" || password == "" || confirmPassword == "" {
                self.errorMessage = "Email, display name and password cannot be empty."
                return
            }

            do {
                try await authService.register(email: email, displayName: displayName, password: password)
                try await authService.login(email: email, password: password)
                succeed.wrappedValue = true
            } catch RegisterError.userAlreadyExists {
                self.errorMessage = "User already exists. Please try logging in."
            } catch RegisterError.customError(let error) {
                self.errorMessage = error
            } catch {
                self.errorMessage = "Error when registering: \(error.localizedDescription)"
            }
        }
    }
}
