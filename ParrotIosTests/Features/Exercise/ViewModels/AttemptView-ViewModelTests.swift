//
//  AttemptView-ViewModelTests.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Testing
import Foundation

@testable import ParrotIos

@Suite("AttemptView ViewModel Tests")
struct AttemptView_ViewModelTests {
    
    var mockParrotApiService: (ParrotApiServiceProtocol & CallTracking) = MockParrotApiService() as (ParrotApiServiceProtocol & CallTracking)
    var mockAudioRecorder: (AudioRecorderProtocol & CallTracking) = MockAudioRecorder() as (AudioRecorderProtocol & CallTracking)
    var mockAudioPlayer: (AudioPlayerProtocol & CallTracking) = MockAudioPlayer() as (AudioPlayerProtocol & CallTracking)
    
    var viewModel: AttemptView.ViewModel!
    let exercise1 = Exercise(id: 1, word: Word(id: 2, text: "a", phonemes: [Phoneme(id: 0, ipa: "a", respelling: "a")]), previousExerciseID: 0, nextExerciseID: 2)
    let exercise2 = Exercise(id: 2, word: Word(id: 3, text: "b", phonemes: [Phoneme(id: 1, ipa: "b", respelling: "b")]), previousExerciseID: 1, nextExerciseID: 2)
    let url = URL(fileURLWithPath: "test.url")
    
    init() {
        viewModel = AttemptView.ViewModel(exerciseId: 0, audioRecoder: mockAudioRecorder, audioPlayer: mockAudioPlayer, parrotApi: mockParrotApiService)
    }
    
    @Test("Fetch exercise retrieves the correct exercise")
    func testFetchExercise() async throws {
        // Setup
        mockParrotApiService.stub(method: ParrotApiServiceMethods.getExercise, toReturn: Result<ParrotIos.Exercise, ParrotIos.ParrotApiError>.success(exercise2))
        
        // Act
        await viewModel.fetchExercise(withID: exercise2.id)
        
        // Assert
        #expect(viewModel.exercise! == exercise2)
        #expect(viewModel.exerciseId == exercise2.id)
        
        // Verify call
        let parameterId = exercise2.id
        
        #expect(mockParrotApiService.callCounts(for: ParrotApiServiceMethods.getExercise) == 1)
        mockParrotApiService.assertCallArguments(for: ParrotApiServiceMethods.getExercise, matches: [parameterId])
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
        mockParrotApiService.stub(method: ParrotApiServiceMethods.getExercise, toReturn: Result<ParrotIos.Exercise, ParrotIos.ParrotApiError>.success(exercise1))
        await viewModel.fetchExercise(withID: exercise1.id)
        mockParrotApiService.stub(method: ParrotApiServiceMethods.postExerciseAttempt, toReturn: Result<ParrotIos.AttemptResponse, ParrotIos.ParrotApiError>.success(AttemptResponse(recording_id: 1, score: 2, recording_phonemes: [], xp_gain: 1)))
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
        mockParrotApiService.stub(method: ParrotApiServiceMethods.getExercise, toReturn: Result<ParrotIos.Exercise, ParrotIos.ParrotApiError>.success(exercise1))
        await viewModel.fetchExercise(withID: exercise1.id)
        let attemptResponse = AttemptResponse(recording_id: 2, score: 2, recording_phonemes: [Phoneme(id: 1, ipa: "a", respelling: "a")], xp_gain: 2)
        mockParrotApiService.stub(method: ParrotApiServiceMethods.postExerciseAttempt, toReturn: Result<ParrotIos.AttemptResponse, ParrotIos.ParrotApiError>.success(attemptResponse))
        
        // Act
        await viewModel.uploadRecording(recordingURL: url)
        
        // Assert
        #expect(viewModel.score == attemptResponse.score)
        #expect(viewModel.recording_phonemes == attemptResponse.recording_phonemes)
        #expect(viewModel.xp_gain == attemptResponse.xp_gain)
        #expect(!viewModel.isLoading)
        
        // Verify calls
        #expect(mockParrotApiService.callCounts(for: ParrotApiServiceMethods.postExerciseAttempt) == 1)
        mockParrotApiService.assertCallArguments(for: ParrotApiServiceMethods.postExerciseAttempt, matches: [url, exercise1])
    }
    
    @Test("Play word sends the right word to the audio player")
    func testPlayWord() async throws {
        // Setup
        mockParrotApiService.stub(method: ParrotApiServiceMethods.getExercise, toReturn: Result<ParrotIos.Exercise, ParrotIos.ParrotApiError>.success(exercise1))
        await viewModel.fetchExercise(withID: exercise1.id)
        
        let rate = 0.5
        let lang = "en-US"
        
        // Act
        viewModel.playWord()
        
        // Assert
        #expect(!viewModel.isPlaying)
        
        // Verify Calls
        #expect(mockAudioPlayer.callCounts(for: AudioPlayerMethods.play) == 1)
        mockAudioPlayer.assertCallArguments(for: AudioPlayerMethods.play, matches: [exercise1.word.text, rate, lang])
    }
}
