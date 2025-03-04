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
    var mockAudioSynthesizer: (AudioSynthesizerProtocol & CallTracking) = MockAudioSynthesizer() as (AudioSynthesizerProtocol & CallTracking)

    var viewModel: ExerciseView.ViewModel!
    let exercise = Exercise(
        id: 1,
        word: Word(
            id: 2,
            text: "a",
            phonemes: [Phoneme(id: 0, ipa: "a", respelling: "a", cdnPath: "")]
        ),
        isCompleted: false
    )
    let attemptResponse: ExerciseAttempt = ExerciseAttempt(
        recordingId: 1,
        score: 1,
        phonemes: [
            (Phoneme(id: 5, ipa: "m'", respelling: "m", cdnPath: ""), Phoneme(id: 5, ipa: "m'", respelling: "m", cdnPath: "")),
            (Phoneme(id: 6, ipa: "aʊ", respelling: "ow", cdnPath: ""), nil),
            (nil, Phoneme(id: 7, ipa: "s", respelling: "s", cdnPath: ""))
        ],
        xpGain: 2,
        exerciseIsCompleted: false
    )

    let url = URL(fileURLWithPath: "test.url")

    init() {
        viewModel = ExerciseView.ViewModel(exerciseId: exercise.id, audioRecoder: mockAudioRecorder, audioSynthesizer: mockAudioSynthesizer, parrotApi: mockParrotApiService)
        mockParrotApiService.stub(method: ParrotApiServiceMethods.getExercise, toReturn: exercise)
    }

    @Test("Start recording calls the audio recorder")
    func testStartRecording() async throws {
        // Setup
        await viewModel.loadExercise()

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
        await viewModel.loadExercise()
        mockAudioRecorder.stub(method: AudioRecorderMethods.getRecordingURL, toReturn: url)
        mockParrotApiService.stub(method: ParrotApiServiceMethods.postExerciseAttempt, toReturn: attemptResponse)
        
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
        await viewModel.loadExercise()
        mockParrotApiService.stub(method: ParrotApiServiceMethods.postExerciseAttempt, toReturn: attemptResponse)

        // Act
        await viewModel.uploadRecording(recordingURL: url)

        // Assert
        #expect(viewModel.lastAttempt == attemptResponse)
        #expect(!viewModel.isLoading)

        // Verify calls
        #expect(mockParrotApiService.callCounts(for: ParrotApiServiceMethods.postExerciseAttempt) == 1)
        mockParrotApiService.assertCallArguments(for: ParrotApiServiceMethods.postExerciseAttempt, matches: [url, exercise])
    }

    @Test("Play word sends the right word to the audio player")
    func testPlayWord() async throws {
        // Setup
        await viewModel.loadExercise()
        let rate = 0.5
        let lang = "en-US"

        // Act
        viewModel.playWord()

        // Assert
        #expect(!viewModel.isPlaying)

        // Verify Calls
        #expect(mockAudioSynthesizer.callCounts(for: AudioSynthesizerMethods.play) == 1)
        mockAudioSynthesizer.assertCallArguments(for: AudioSynthesizerMethods.play, matches: [exercise.word.text, rate, lang])
    }
}
