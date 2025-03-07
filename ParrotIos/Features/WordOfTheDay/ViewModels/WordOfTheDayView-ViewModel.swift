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
        
        private(set) var awaitingFeedback: Bool = false

        private(set) var word: Word?
        private(set) var feedback: Feedback?
        private(set) var success: Bool?

        init(
            audioRecoder: AudioRecorderProtocol = AudioRecorder(),
            parrotApi: ParrotApiServiceProtocol = ParrotApiService(
                webService: WebService(), authService: AuthService.instance)
        ) {
            self.audioRecorder = audioRecoder
            self.parrotApi = parrotApi
        }

        func loadWordOfTheDay() async {
            isLoading = true
            errorMessage = nil
            feedback = nil
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
            if let url = audioRecorder.getRecordingURL() {
                await uploadRecording(recordingURL: url)
            }
        }

        func uploadRecording(recordingURL: URL) async {
            awaitingFeedback = true
            errorMessage = nil

            do {
                let attemptResponse = try await parrotApi.postWordOfTheDayAttempt(recordingURL: recordingURL)
                self.feedback = attemptResponse.feedback
                self.success = attemptResponse.success
            } catch {
                errorMessage = error.localizedDescription
            }
            awaitingFeedback = false
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
