//
//  ExerciseView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 26/02/2025.
//

import SwiftUI
import Foundation

extension ExerciseView {
    @Observable
    class ViewModel {
        private let audioRecorder: AudioRecorderProtocol
        private let audioSynthesizer: AudioSynthesizerProtocol
        private let parrotApi: ParrotApiServiceProtocol
        private let authService: AuthServiceProtocol

        private(set) var isRecording: Bool = false
        private(set) var isPlaying: Bool = false
        private(set) var isLoading: Bool = false
        private(set) var isSuccess: Bool = true
        private(set) var errorMessage: String?

        private(set) var exerciseId: Int
        private(set) var exercise: Exercise?
        private(set) var lastAttempt: ExerciseAttempt?
        var isCompleted: Bool {
            return (exercise != nil && exercise!.isCompleted) ||
                (lastAttempt != nil && lastAttempt!.exerciseIsCompleted ?? false)
        }

        init(
            exerciseId: Int,
            audioRecoder: AudioRecorderProtocol = AudioRecorder(),
            audioSynthesizer: AudioSynthesizerProtocol = AudioSynthesizer(),
            parrotApi: ParrotApiServiceProtocol = ParrotApiService(
                webService: WebService(), authService: AuthService.instance),
            authService: AuthServiceProtocol = AuthService.instance
        ) {
            self.exerciseId = exerciseId
            self.audioRecorder = audioRecoder
            self.audioSynthesizer = audioSynthesizer
            self.parrotApi = parrotApi
            self.authService = authService
        }

        func loadExercise() async {
            isLoading = true
            errorMessage = nil
            do {
                self.exercise = try await parrotApi.getExercise(exerciseId: exerciseId)
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

            do {
                self.lastAttempt = try await parrotApi.postExerciseAttempt(
                    recordingURL: recordingURL,
                    exercise: exercise!)
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
            let word: String = self.exercise!.word.text
            isPlaying = true
            let userLanguage = authService.userDetails!.language.code
            audioSynthesizer.play(word: word, rate: 0.25, language: userLanguage)
            isPlaying = false
        }
    }
}
