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
        private let audioPlayer: AudioPlayerProtocol
        private let parrotApi: ParrotApiServiceProtocol

        private(set) var isRecording: Bool = false
        private(set) var isPlaying: Bool = false
        private(set) var isLoading: Bool = false
        private(set) var disableRecording: Bool = false
        private(set) var errorMessage: String?

        private(set) var exercise: Exercise
        private(set) var score: Int?
        private(set) var feedbackPhonemes: [(Phoneme?, Phoneme?)]?
        private(set) var xpGain: Int?

        init(
            exercise: Exercise,
            audioRecoder: AudioRecorderProtocol = AudioRecorder(),
            audioPlayer: AudioPlayerProtocol = AudioPlayer(),
            parrotApi: ParrotApiServiceProtocol = ParrotApiService(
                webService: WebService(), authService: AuthService.instance)
        ) {
            self.exercise = exercise
            self.audioRecorder = audioRecoder
            self.audioPlayer = audioPlayer
            self.parrotApi = parrotApi
        }

        func startRecording() {
            isRecording = true
            audioRecorder.startRecording()
            disableRecording = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.disableRecording = false  // Re-enable after 1 second
            }
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
                let attemptResponse = try await parrotApi.postExerciseAttempt(
                    recordingURL: recordingURL,
                    exercise: exercise)
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
            let word: String = self.exercise.word.text
            isPlaying = true
            // Rate currently set so that the automated voice speaks slowly
            audioPlayer.play(word: word, rate: 0.5)
            isPlaying = false
        }
    }
}
