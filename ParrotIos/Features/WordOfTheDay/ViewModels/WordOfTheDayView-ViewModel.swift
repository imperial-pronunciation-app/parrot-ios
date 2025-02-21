//
//  WordOfTheDayView-ViewModel.swift
//  ParrotIos
//
//  Created by Henry Yu on 20/2/2025.
//

import Foundation
import SwiftUI

extension WordOfTheDayView {

    @Observable
    class ViewModel {
        private let audioRecorder: AudioRecorderProtocol
        private let parrotApi: ParrotApiServiceProtocol

        private(set) var isRecording: Bool = false
        private(set) var isPlaying: Bool = false
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?

        private(set) var word: Word?
        private(set) var score: Int?
        private(set) var recording_phonemes: [Phoneme]?
        private(set) var xp_gain: Int?

        init(audioRecoder: AudioRecorderProtocol = AudioRecorder(), parrotApi: ParrotApiServiceProtocol = ParrotApiService(webService: WebService(), authService: AuthService())) {
            self.audioRecorder = audioRecoder
            self.parrotApi = parrotApi
        }

        func loadWordOfTheDay() async {
            isLoading = true
            errorMessage = nil
            score = nil
            recording_phonemes = nil
            xp_gain = nil
            do {
                self.word = try await parrotApi.getWordOfTheDay()
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
                let attemptResponse = try await parrotApi.postWordOfTheDayAttempt(recordingURL: recordingURL)
                self.score = attemptResponse.score
                self.recording_phonemes = attemptResponse.recording_phonemes
                self.xp_gain = attemptResponse.xp_gain
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
    }
}
