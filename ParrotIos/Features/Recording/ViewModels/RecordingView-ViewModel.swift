//
//  RecordingView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

#if DEBUG
    extension RecordingView.ViewModel {
        // Getters and setters for testing
        var testWord: Word? {
            get { word }
            set { word = newValue }
        }
        var testIsRecording: Bool {
            get { isRecording }
            set { isRecording = newValue }
        }
        var testIsLoading: Bool {
            get { isLoading }
            set { isLoading = newValue }
        }
        var testErrorMessage: String? {
            get { errorMessage }
            set { errorMessage = newValue }
        }
        var testScore: Int? {
            get { score }
            set { score = newValue }
        }
    }
#endif

import Foundation

extension RecordingView {
    @Observable
    class ViewModel {
        private let audioRecorder: AudioRecorder
        private let parrotApi: ParrotApiService
        
        private(set) var isRecording: Bool = false
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?
        
        private(set) var word: Word?
        private(set) var score: Int?
        
        init(audioRecorder: AudioRecorder = AudioRecorder(), parrotApi: ParrotApiService = ParrotApiService()) {
            self.audioRecorder = audioRecorder
            self.parrotApi = parrotApi
        }
        
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
            await uploadRecording(recordingURL: audioRecorder.getAudioFileURL())
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
    }
}
