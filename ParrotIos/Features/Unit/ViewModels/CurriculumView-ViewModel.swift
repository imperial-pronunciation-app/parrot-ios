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

        private let parrotApi = ParrotApiService()

        func loadCurriculum() async {
            self.isLoading = true

            do {
                try self.curriculum = await parrotApi.getCurriculum()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
