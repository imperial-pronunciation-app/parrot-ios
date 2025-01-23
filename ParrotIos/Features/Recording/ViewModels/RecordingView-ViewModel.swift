//
//  RecordingView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import Foundation
import MapKit
import SoundControlKit

extension RecordingView {
    @Observable
    class ViewModel {
        private let audioRecorder = AudioRecorder()
        
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?
        
        private(set) var word: Word?
        private(set) var score: Int?
        
        private let parrotApi = ParrotApiService()
        
        func fetchNewWord() async {
            word = nil
            score = nil
            await fetchRandomWord()
        }
        
        func fetchRandomWord() async {
            isLoading = true
            errorMessage = nil
            
            let result = await parrotApi.getRandomWord()
            switch result {
            case .success(let word):
                self.word = word
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
        
        func isRecording() -> Bool {
            return audioRecorder.isRecording
        }
        
        func stopRecording() async {
            audioRecorder.stopRecording()
            await uploadRecording(recordingURL: audioRecorder.audioRecorder.url)
        }
        
        func uploadRecording(recordingURL: URL) async {
            isLoading = true
            errorMessage = nil
            
            let word: Word = self.word!
            let result = await parrotApi.postRecording(recordingURL: recordingURL, word: word)
            switch result {
            case .success(let recordingResponse):
                self.score = recordingResponse.score
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
        
        func toggleRecording() async {
            if isRecording() {
                await stopRecording()
            } else {
                audioRecorder.startRecording()
            }
        }

    }
}
