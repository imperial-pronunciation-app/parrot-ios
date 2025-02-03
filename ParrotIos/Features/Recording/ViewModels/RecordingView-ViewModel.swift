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
        private let audioRecorder = AudioRecorder()
        
        private(set) var isRecording: Bool = false
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?
        
        private(set) var word: Word?
        private(set) var score: Int?
        
        private let parrotApi = ParrotApiService()
        
        // Put this in the init when merging
        private let audioPlayer = AudioPlayer()
        
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
        
        func startRecording() {
            isRecording = true
            audioRecorder.startRecording()
        }
        
        func stopRecording() async {
            isRecording = false
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
            if isRecording {
                await stopRecording()
            } else {
                startRecording()
            }
        }
        
        func playPhoneme() {
            let phoneme: String = self.word?.word ?? ""
            // Rate currently set so that the automated voice speaks slowly
            audioPlayer.play(phoneme: phoneme, rate: 0.3)
        }

    }
}
