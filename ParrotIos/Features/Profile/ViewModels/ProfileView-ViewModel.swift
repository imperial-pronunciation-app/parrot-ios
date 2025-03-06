//
//  ProfileView-ViewModel.swift
//  ParrotIos
//
//  Created by James Watling on 05/03/2025.
//

import SwiftUI

extension ProfileView {
    @Observable
    class ViewModel {
        private let authService: AuthServiceProtocol
        private let parrotApiService: ParrotApiServiceProtocol

        var userDetails: UserDetails {
            authService.userDetails!
        }

        private(set) var languages: [Language] = []

        init(
            authService: AuthServiceProtocol = AuthService.instance,
            parrotApiService: ParrotApiServiceProtocol = ParrotApiService()
        ) {
            self.authService = authService
            self.parrotApiService = parrotApiService
        }

        private func getLanguages() async throws {
            languages = try await parrotApiService.getLanguages()
        }

        func onLoad() async throws {
            try await getLanguages()
        }

        func logout() async throws {
            try await authService.logout()
        }

        func updateDetails(name: String, email: String, languageCode: Int) async throws {
            try await authService.updateDetails(name: name, email: email, language: languageCode)
        }
    }
}
