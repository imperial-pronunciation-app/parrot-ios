//
//  CurriculumView-ViewModel.swift
//  ParrotIos
//
//  Created by jn1122 on 06/02/2025.
//
import SwiftUI

extension CurriculumView {
    @Observable
    class ViewModel {
        private(set) var curriculum: Curriculum?
        private(set) var errorMessage: String?
        private(set) var isLoading: Bool = true
        private let authService = AuthService.instance

        private let parrotApi = ParrotApiService()

        var userDetails: UserDetails {
            authService.userDetails!
        }

        @MainActor
        func loadCurriculum() async {
            self.isLoading = true

            do {
                try self.curriculum = await parrotApi.getCurriculum()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }

        func streaks() -> Int {
            return authService.userDetails!.loginStreak
        }
    }
}
