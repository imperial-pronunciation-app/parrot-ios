//
//  ExerciseView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 27/02/2025.
//

import Testing
import Foundation

@testable import ParrotIos

@Suite("ExerciseView ViewModel Tests")
struct ExerciseView_ViewModelTests {
    var mockParrotApiService: (ParrotApiServiceProtocol & CallTracking) = MockParrotApiService() as (ParrotApiServiceProtocol & CallTracking)
    var mockAudioRecorder: (AudioRecorderProtocol & CallTracking) = MockAudioRecorder() as (AudioRecorderProtocol & CallTracking)
    var mockAudioPlayer: (AudioPlayerProtocol & CallTracking) = MockAudioPlayer() as (AudioPlayerProtocol & CallTracking)

    var viewModel: ExerciseView.ViewModel!
    let exercise = Exercise(id: 1, word: Word(id: 2, text: "a", phonemes: [Phoneme(id: 0, ipa: "a", respelling: "a")]))

    let url = URL(fileURLWithPath: "test.url")

    init() {
        viewModel = ExerciseView.ViewModel(exercise: exercise, audioRecoder: mockAudioRecorder, audioPlayer: mockAudioPlayer, parrotApi: mockParrotApiService)
    }


    @Test("Start recording calls the audio recorder")
    func testStartRecording() throws {
        // Act
        viewModel.startRecording()

        // Assert
        #expect(viewModel.isRecording)

        // Verify call
        #expect(mockAudioRecorder.callCounts(for: AudioRecorderMethods.startRecording) == 1)
    }

    @Test("Stop recording calls the audio recorder and uploads")
    func testStopRecording() async throws {
        // Setup
        mockAudioRecorder.stub(method: AudioRecorderMethods.getRecordingURL, toReturn: url)
        mockParrotApiService.stub(method: ParrotApiServiceMethods.postExerciseAttempt, toReturn: AttemptResponse(recordingId: 1, score: 1, phonemes: [
            (Phoneme(id: 5, ipa: "m'", respelling: "m"), Phoneme(id: 5, ipa: "m'", respelling: "m")),
            (Phoneme(id: 6, ipa: "aʊ", respelling: "ow"), nil),
            (nil, Phoneme(id: 7, ipa: "s", respelling: "s"))], xpGain: 2))
        
        // Act
        await viewModel.stopRecording()

        // Assert
        #expect(!viewModel.isRecording)

        // Verify calls
        #expect(mockAudioRecorder.callCounts(for: AudioRecorderMethods.stopRecording) == 1)
        #expect(mockAudioRecorder.callCounts(for: AudioRecorderMethods.getRecordingURL) == 1)
    }

    @Test("Upload recording posts an exercise attempt and updates internal state")
    func testUploadRecordingSuccess() async throws {
        // Setup
        let attemptResponse = AttemptResponse(recordingId: 1, score: 1, phonemes: [
            (Phoneme(id: 5, ipa: "m'", respelling: "m"), Phoneme(id: 5, ipa: "m'", respelling: "m")),
            (Phoneme(id: 6, ipa: "aʊ", respelling: "ow"), nil),
            (nil, Phoneme(id: 7, ipa: "s", respelling: "s"))], xpGain: 2)
        mockParrotApiService.stub(method: ParrotApiServiceMethods.postExerciseAttempt, toReturn: attemptResponse)

        // Act
        await viewModel.uploadRecording(recordingURL: url)

        // Assert
        #expect(viewModel.score == attemptResponse.score)
        #expect(zip(viewModel.feedbackPhonemes!, attemptResponse.phonemes).allSatisfy({ $0 == $1 }))
        #expect(viewModel.xpGain == attemptResponse.xpGain)
        #expect(!viewModel.isLoading)

        // Verify calls
        #expect(mockParrotApiService.callCounts(for: ParrotApiServiceMethods.postExerciseAttempt) == 1)
        mockParrotApiService.assertCallArguments(for: ParrotApiServiceMethods.postExerciseAttempt, matches: [url, exercise])
    }

    @Test("Play word sends the right word to the audio player")
    func testPlayWord() async throws {
        // Setup
        let rate = 0.5
        let lang = "en-US"

        // Act
        viewModel.playWord()

        // Assert
        #expect(!viewModel.isPlaying)

        // Verify Calls
        #expect(mockAudioPlayer.callCounts(for: AudioPlayerMethods.play) == 1)
        mockAudioPlayer.assertCallArguments(for: AudioPlayerMethods.play, matches: [exercise.word.text, rate, lang])
    }
}
