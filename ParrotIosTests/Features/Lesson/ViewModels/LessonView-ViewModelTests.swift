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

    var lesson: Lesson {
        return Lesson(id: 0, title: "Test", exerciseIds: [1, 2], currentExerciseIndex: 0)
    }

    init() {
        mockParrotApiService.stub(method: ParrotApiServiceMethods.getLesson, toReturn: lesson)
    }

    @Test("Fetch lesson retrieves the correct lesson")
    func testFetchLesson() async throws {
        let viewModel = LessonView.ViewModel(lessonId: 0, parrotApi: mockParrotApiService)
        await viewModel.fetchLesson(withID: lesson.id)
        // Assert
        #expect(viewModel.lesson! == lesson)
        #expect(viewModel.totalExercises == 2)
        #expect(viewModel.exerciseId == 1)

        // Verify call
        let parameterId = lesson.id

        #expect(mockParrotApiService.callCounts(for: ParrotApiServiceMethods.getLesson) == 1)
        mockParrotApiService.assertCallArguments(for: ParrotApiServiceMethods.getLesson, matches: [parameterId])
    }
}
