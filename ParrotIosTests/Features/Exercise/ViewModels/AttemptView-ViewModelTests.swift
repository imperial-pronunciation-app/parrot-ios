//
//  AttemptView-ViewModelTests.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Testing

@testable import ParrotIos

@Suite("AttemptView ViewModel Tests")
struct AttemptView_ViewModelTests {
    
    var mockParrotApiService: (ParrotApiServiceProtocol & CallTracking) = MockParrotApiService() as (any ParrotApiServiceProtocol & CallTracking)
    var viewModel: AttemptView.ViewModel!
    let exerciseId = 1
    let exercise1 = Exercise(id: 1, word: Word(id: 2, text: "a", phonemes: [Phoneme(id: 0, ipa: "a", respelling: "a")]), previousExerciseID: 0, nextExerciseID: 2)
    let exercise2 = Exercise(id: 2, word: Word(id: 3, text: "b", phonemes: [Phoneme(id: 1, ipa: "b", respelling: "b")]), previousExerciseID: 1, nextExerciseID: 2)
    
    init() {
        viewModel = AttemptView.ViewModel(exerciseId: exerciseId, audioRecoder: MockAudioRecorder(), audioPlayer: MockAudioPlayer(), parrotApi: mockParrotApiService)
    }
    
    @Test("Fetch exercise retrieves the correct exercise")
    func testFetchExercise() async throws {
        // Setup
        mockParrotApiService.stub(method: "getExercise", toReturn: Result<ParrotIos.Exercise, ParrotIos.ParrotApiError>.success(exercise2))
        
        // Act
        await viewModel.fetchExercise(withID: exerciseId)
        
        // Assert
        #expect(viewModel.exercise! == exercise2)
        
        // Verify call
        let parameterId = exerciseId
        
        #expect(mockParrotApiService.callCount(for: "getExercise") == 1)
        mockParrotApiService.assertCallArguments(for: "getExercise", at: 0, matches: [parameterId])
    }

}
