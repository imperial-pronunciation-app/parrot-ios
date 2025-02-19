//
//  AuthViewModel.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import Foundation
import Combine
import SwiftUI

extension LoginView {

    protocol ViewModelProtocol {
        var errorMessage: String? { get }
        func login(username: String, password: String, succeed: Binding<Bool>) async
        func logout() async
    }

    @Observable
    class ViewModel: ViewModelProtocol {
        private(set) var errorMessage: String?
        
        func login(username: String, password: String, succeed: Binding<Bool>) async {
            do {
                try await AuthService.instance.login(username: username, password: password)
                succeed.wrappedValue = true
            } catch LoginError.badCredentials {
                self.errorMessage = "Incorrect username or password."
            } catch LoginError.userNotVerified {
                self.errorMessage = "User not verified."
            } catch LoginError.customError(let error) {
                self.errorMessage = error
            } catch {
                self.errorMessage = "Unknown error occurred: \(error.localizedDescription)"
            }
        }
        
        func logout() async {
            do {
                try await AuthService.instance.logout()
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
