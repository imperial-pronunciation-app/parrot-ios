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
        private(set) var isLoading: Bool = false
        
        private let parrotApi = ParrotApiService()
        
        init() {
            Task {
                await loadCurriculum()
            }
        }
        
        private func loadCurriculum() async {
            self.isLoading = true
            let getCurriculumResult = await parrotApi.getCurriculum()
            
            switch getCurriculumResult {
            case .success(let c):
                self.curriculum = c
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
