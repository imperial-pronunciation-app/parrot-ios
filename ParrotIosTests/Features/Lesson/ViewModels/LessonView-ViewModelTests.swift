//
//  LessonView-ViewModelTests.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Testing
import Foundation

@testable import ParrotIos

@Suite("LessonView ViewModel Tests")
struct LessonView_ViewModelTests {
    var mockParrotApiService: (ParrotApiServiceProtocol & CallTracking) = MockParrotApiService() as (ParrotApiServiceProtocol & CallTracking)

    var viewModel: LessonView.ViewModel!
    let exercise1 = Exercise(id: 1, word: Word(id: 2, text: "a", phonemes: [Phoneme(id: 0, ipa: "a", respelling: "a")]))
    let exercise2 = Exercise(id: 2, word: Word(id: 3, text: "b", phonemes: [Phoneme(id: 1, ipa: "b", respelling: "b")]))
    var lesson: Lesson {
        return Lesson(id: 0, title: "Test", exercises: [exercise1, exercise2], currentExerciseIndex: 0)
    }

    init() {
        viewModel = LessonView.ViewModel(lessonId: 0, parrotApi: mockParrotApiService)
    }

    @Test("Fetch exercise retrieves the correct exercise")
    func testFetchLesson() async throws {
        // Setup
        mockParrotApiService.stub(method: ParrotApiServiceMethods.getLesson, toReturn: lesson)

        // Act
        await viewModel.fetchLesson(withID: lesson.id)

        // Assert
        #expect(viewModel.lesson! == lesson)
        #expect(viewModel.totalExercises == 2)
        #expect(viewModel.exercise == exercise1)

        // Verify call
        let parameterId = lesson.id

        #expect(mockParrotApiService.callCounts(for: ParrotApiServiceMethods.getLesson) == 1)
        mockParrotApiService.assertCallArguments(for: ParrotApiServiceMethods.getLesson, matches: [parameterId])
    }
}
