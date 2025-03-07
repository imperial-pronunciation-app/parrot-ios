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
        private let lessonId: Int
        private(set) var lesson: Lesson?
        private(set) var exerciseIndex: Int?
        var totalExercises: Int? {
            lesson?.exerciseIds.count
        }
        var exercise: Int? {
            lesson?.exerciseIds[exerciseIndex!]
        }
        var isFirst: Bool? {
            if let exerciseIndex = exerciseIndex {
                return exerciseIndex == 0
            }
            return nil
        }
        var isLast: Bool? {
            if let totalExercises = totalExercises {
                return exerciseIndex == totalExercises - 1
            }
            return nil
        }
        var exerciseId: Int? {
            return lesson?.exerciseIds[exerciseIndex!]
        }
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?

        private let parrotApi: ParrotApiServiceProtocol

        init(
            lessonId: Int,
            parrotApi: ParrotApiServiceProtocol = ParrotApiService(
                webService: WebService(), authService: AuthService.instance)
        ) {
            self.lessonId = lessonId
            self.parrotApi = parrotApi
        }

        func loadLesson() async {
            await fetchLesson(withID: lessonId)
        }

        @MainActor
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

        @MainActor
        func nextExercise() {
            guard let index = exerciseIndex,
                  let isLast = isLast,
                  !isLast else { return }
            exerciseIndex = index + 1
        }

        @MainActor
        func prevExercise() {
            guard let index = exerciseIndex, let isFirst = isFirst, !isFirst else { return }
            exerciseIndex = index - 1
        }
    }
}
