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
        private let audioRecorder: AudioRecorderProtocol
        private let audioPlayer: AudioPlayerProtocol
        private let parrotApi: ParrotApiServiceProtocol
        
        private(set) var isRecording: Bool = false
        private(set) var isPlaying: Bool = false
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?
        
        private(set) var exerciseId: Int
        private(set) var exercise: Exercise?
        private(set) var score: Int?
        private(set) var feedbackPhonemes: [PhonemePair]?
        private(set) var xpGain: Int?
        
        init(exerciseId: Int, audioRecoder: AudioRecorderProtocol = AudioRecorder(), audioPlayer: AudioPlayerProtocol = AudioPlayer(), parrotApi: ParrotApiServiceProtocol = ParrotApiService(webService: WebService(), authService: AuthService())) {
            self.audioRecorder = audioRecoder
            self.audioPlayer = audioPlayer
            self.parrotApi = parrotApi
            self.exerciseId = exerciseId
        }
        
        func loadExercise() async {
            await fetchExercise(withID: self.exerciseId)
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
            score = nil
            feedbackPhonemes = nil
            xpGain = nil
            do {
                self.exercise = try await parrotApi.getExercise(exerciseId: id)
                self.exerciseId = id
            } catch {
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
            await uploadRecording(recordingURL: audioRecorder.getRecordingURL())
        }
        
        func uploadRecording(recordingURL: URL) async {
            isLoading = true
            errorMessage = nil
            
            let exercise: Exercise = self.exercise!
            do {
                let attemptResponse = try await parrotApi.postExerciseAttempt(recordingURL: recordingURL, exercise: exercise)
                self.score = attemptResponse.score
                self.feedbackPhonemes = attemptResponse.phonemes
                self.xpGain = attemptResponse.xpGain
            } catch {
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

        func playWord() {
            let word: String = self.exercise?.word.text ?? ""
            isPlaying = true
            // Rate currently set so that the automated voice speaks slowly
            audioPlayer.play(word: word, rate: 0.5)
            isPlaying = false
        }
    }
}
