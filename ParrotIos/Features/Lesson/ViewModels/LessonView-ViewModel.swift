//
//  LessonView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 26/02/2025.
//
import SwiftUI

extension LessonView {
    @Observable
    class ViewModel {
        private(set) var lesson: Lesson?
        private(set) var exerciseIndex: Int?
        var totalExercises: Int? {
            lesson?.exercises.count
        }
        var exercise: Exercise? {
            lesson?.exercises[exerciseIndex!]
        }
        var isFirst: Bool {
            return exerciseIndex == 0
        }
        var isLast: Bool {
            return exerciseIndex == lesson!.exercises.count - 1
        }
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?

        private let parrotApi: ParrotApiServiceProtocol

        init(
            lessonId: Int,
            parrotApi: ParrotApiServiceProtocol = ParrotApiService(
                webService: WebService(), authService: AuthService())
        ) {
            self.parrotApi = parrotApi
            Task {
                await fetchLesson(withID: lessonId)
            }
        }

        func fetchLesson(withID id: Int) async {
            isLoading = true
            errorMessage = nil
            do {
                self.lesson = try await parrotApi.getLesson(lessonId: id)
                self.exerciseIndex = lesson!.currentExerciseIndex
            } catch {
                errorMessage = error.localizedDescription
            }

            isLoading = false
        }

        func nextExercise() {
            guard let lesson = lesson, let index = exerciseIndex, index < lesson.exercises.count - 1 else { return }
            exerciseIndex = index + 1
        }

        func prevExercise() {
            guard let index = exerciseIndex, index > 0 else { return }
            exerciseIndex = index - 1
        }
    }
}
