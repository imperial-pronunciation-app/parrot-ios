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
            } else if let exerciseId = viewModel.exerciseId,
                      let isFirst = viewModel.isFirst,
                      let isLast = viewModel.isLast {
                VStack {
                    ExerciseView(
                        exerciseId: exerciseId,
                        prevExercise: { viewModel.prevExercise() },
                        nextExercise: { viewModel.nextExercise() },
                        isFirst: isFirst,
                        isLast: isLast
                    )
                    .id(exerciseId)
                    .padding(.bottom)
                    ProgressView(value: Double(viewModel.exerciseIndex!), total: Double(viewModel.totalExercises!))
                        .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                        .padding([.horizontal, .bottom])
                        .animation(.easeOut(duration: 0.8), value: viewModel.exerciseIndex!)
                }
                .navigationTitle(viewModel.lesson!.title)
                .sensoryFeedback(.increase, trigger: viewModel.exerciseIndex)
            }
        }.onAppear {
            Task {
                await viewModel.loadLesson()
            }
        }
    }
}
