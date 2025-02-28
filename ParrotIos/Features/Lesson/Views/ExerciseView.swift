//
//  ExerciseView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI

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
        Group {
            if viewModel.isLoading {
              VStack {
                  Spacer()
                  UtilComponents.loadingView
                  Spacer()
              }
            } else if let errorMessage = viewModel.errorMessage {
                UtilComponents.errorView(errorMessage: errorMessage)
            } else {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 32) {
                        if let exercise = viewModel.exercise {
                            if let feedback = viewModel.lastAttempt {
                                ScoreView(score: feedback.score)
                                    .padding(.horizontal, 128)
                                FeedbackView(
                                    score: feedback.score,
                                    word: exercise.word,
                                    feedbackPhonemes: feedback.phonemes,
                                    xpGain: feedback.xpGain)
                            } else {
                                WordView(word: exercise.word)
                            }
                        }
                    }

                    Spacer()

                    
                    Button(action: { viewModel.playWord() }) {
                        Image(systemName: "speaker.wave.3")
                            .font(.title3)
                            .frame(width: 50, height: 50)
                    }
                    .buttonStyle(.bordered)
                    .tint(.accentColor)
                    .clipShape(Circle())

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

                        Button(action: {
                            Task {
                                await viewModel.toggleRecording()
                            }
                        }) {
                            Image(systemName: "mic")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(viewModel.isRecording ? Color.red.opacity(0.8) : Color.accentColor)
                                .clipShape(Circle())
                        }
                        .disabled(viewModel.disableRecording)

                        Spacer()

                        ZStack(alignment: .trailing) {
                            Button(action: {
                                isLast ? dismiss() : nextExercise()
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
