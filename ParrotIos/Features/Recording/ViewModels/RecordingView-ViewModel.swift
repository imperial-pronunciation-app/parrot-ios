//
//  RecordingView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import Foundation

extension RecordingView {
    @Observable
    class ViewModel {
        private(set) var word: Word?
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?
        
        private let webService = WebService()
        
        func fetchRandomWord() async {
            isLoading = true
            errorMessage = nil
            
            let urlString = "https://pronunciation-app-backend.doc.ic.ac.uk/api/v1/random_word"
            if let fetchedWord: Word = await webService.downloadData(fromURL: urlString) {
                self.word = fetchedWord
            } else {
                errorMessage = "Failed to fetch the word."
            }
            
            isLoading = false
        }
    }
}
