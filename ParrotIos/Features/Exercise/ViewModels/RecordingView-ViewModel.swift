//
//  RecordingView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import Foundation

extension AttemptView {
    @Observable
    class ViewModel {
        private let audioRecorder = AudioRecorder()
        
        private(set) var isRecording: Bool = false
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?
        
        private(set) var exercise: Exercise?
        private(set) var score: Int?
        
        private let parrotApi = ParrotApiService()
        
        func fetchExercise() async {
            score = nil
            await fetchNextExercise()
        }
        
        func fetchNextExercise() async {
            isLoading = true
            errorMessage = nil
            // Should never be nil, so should never triger getting the 0 exercise
            let result = await parrotApi.getExercise(exerciseId: self.exercise?.nextExerciseID ?? 0)
            switch result {
            case .success(let exercise):
                self.exercise = exercise
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
            
            let exercise: Exercise = self.exercise!
            let result = await parrotApi.postExerciseAttempt(recordingURL: recordingURL, exercise: exercise)
            switch result {
            case .success(let attemptResponse):
                self.score = attemptResponse.score
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
