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
        
        private let authService = AuthService()
        
        func register(email: String, password: String, confirmPassword: String, succeed: Binding<Bool>) async {
            if password != confirmPassword {
                self.errorMessage = "Password and confirmation do not match."
                return
            }
            
            do {
                try await authService.register(email: email, password: password)
                try await authService.login(username: email, password: password)
                succeed.wrappedValue = true
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
