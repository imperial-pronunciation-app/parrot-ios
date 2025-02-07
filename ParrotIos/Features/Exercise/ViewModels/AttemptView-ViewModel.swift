//
//  AttemptView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI
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
        private(set) var recording_phonemes: [Phoneme]?
        private(set) var xp_gain: Int?
        
        private let parrotApi = ParrotApiService()
        
        init(exerciseId: Int) {
            Task {
                await fetchExercise(withID: exerciseId)
            }
        }
        
        func fetchNextExercise(finish: Binding<Bool>) async {
            if let nextExerciseID = self.exercise!.nextExerciseID {
                await fetchExercise(withID: nextExerciseID)
            } else {
                finish.wrappedValue = true
            }
        }
        
        func fetchExercise(withID id: Int) async {
            isLoading = true
            errorMessage = nil
            let result = await parrotApi.getExercise(exerciseId: id)
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
                self.recording_phonemes = attemptResponse.recording_phonemes
                self.xp_gain = attemptResponse.xp_gain
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
