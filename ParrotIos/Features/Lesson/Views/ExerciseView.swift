//
//  ExerciseView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI

extension Notification.Name {
    static let didDismissExerciseView = Notification.Name("didDismissExerciseView")
}

struct ExerciseView: View {
    @State private var viewModel: ViewModel
    private let prevExercise: () -> Void
    private let nextExercise: () -> Void
    private let isFirst: Bool
    private let isLast: Bool

    @Environment(\.dismiss) private var dismiss

    init(
        exerciseId: Int,
        prevExercise: @escaping () -> Void,
        nextExercise: @escaping () -> Void,
        isFirst: Bool,
        isLast: Bool
    ) {
        self.viewModel = ViewModel(exerciseId: exerciseId)
        self.prevExercise = prevExercise
        self.nextExercise = nextExercise
        self.isFirst = isFirst
        self.isLast = isLast
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                UtilComponents.loadingView
            } else if let errorMessage = viewModel.errorMessage {
                UtilComponents.errorView(errorMessage: errorMessage)
            } else {
                VStack {
                    Spacer()

                    if let exercise = viewModel.exercise {
                        WordView(
                            word: exercise.word,
                            score: viewModel.lastAttempt?.score,
                            feedbackPhonemes: viewModel.lastAttempt?.phonemes,
                            xpGain: viewModel.lastAttempt?.xpGain,
                            success: viewModel.lastAttempt?.success
                        )
                    }

                    Spacer()

                    AudioButton(action: { viewModel.playWord() })

                    Spacer()

                    HStack {
                        ZStack(alignment: .leading) {
                            if !isFirst {
                                Button(action: {
                                    prevExercise()
                                }) {
                                    Image(systemName: "arrow.left")
                                        .font(.title)
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                            }
                        }
                        .frame(width: 80, alignment: .leading)

                        Spacer()

                        RecordingButton(
                            isRecording: viewModel.isRecording,
                            isDisabled: viewModel.disableRecording,
                            action: viewModel.toggleRecording
                        )

                        Spacer()

                        ZStack(alignment: .trailing) {
                            Button(action: {
                                if isLast {
                                    NotificationCenter.default.post(name: .didDismissExerciseView, object: nil)
                                    dismiss()
                                } else {
                                    nextExercise()
                                }
                            }) {
                                if isLast {
                                    Text("Finish")
                                } else {
                                    Image(systemName: "arrow.right")
                                        .font(.title)
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(viewModel.isCompleted ? Color.accentColor : .gray)
                            .buttonBorderShape(.capsule)
                            .disabled(!viewModel.isCompleted)
                        }
                        .frame(width: 80, alignment: .trailing)
                    }
                    .padding(.horizontal, 32)
                }
            }
        }.onAppear {
            Task {
                await viewModel.loadExercise()
            }
        }
    }
}
