//
//  LessonView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 26/02/2025.
//
import SwiftUI

struct LessonView: View {
    @State private var viewModel: ViewModel

    init(lessonId: Int) {
        self.viewModel = ViewModel(lessonId: lessonId)
    }

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                UtilComponents.loadingView
            } else if let errorMessage = viewModel.errorMessage {
                UtilComponents.errorView(errorMessage: errorMessage)
            } else if let exercise = viewModel.exercise {
                VStack {
                    ExerciseView(
                        exercise: exercise,
                        prevExercise: { viewModel.prevExercise() },
                        nextExercise: { viewModel.nextExercise() },
                        isFirst: viewModel.isFirst,
                        isLast: viewModel.isLast
                    )
                    .id(exercise.id)
                    .padding(.bottom)
                    ProgressView(value: Double(viewModel.exerciseIndex!), total: Double(viewModel.totalExercises!))
                        .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                        .padding([.horizontal, .bottom])
                }
                .navigationTitle(viewModel.lesson!.title)
            }
        }
    }
}
