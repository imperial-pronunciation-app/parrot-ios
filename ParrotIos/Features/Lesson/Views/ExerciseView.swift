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
        exercise: Exercise,
        prevExercise: @escaping () -> Void,
        nextExercise: @escaping () -> Void,
        isFirst: Bool,
        isLast: Bool
    ) {
        self.viewModel = ViewModel(exercise: exercise)
        self.prevExercise = prevExercise
        self.nextExercise = nextExercise
        self.isFirst = isFirst
        self.isLast = isLast
    }

    var body: some View {
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
                    if let score = viewModel.score,
                       let feedbackPhonemes = viewModel.feedbackPhonemes,
                       let xpGain = viewModel.xpGain {
                        ScoreView(score: score)
                            .padding(.horizontal, 128)
                        FeedbackView(
                            score: score,
                            word: viewModel.exercise.word,
                            feedbackPhonemes: feedbackPhonemes,
                            xpGain: xpGain)
                    } else {
                        WordView(word: viewModel.exercise.word)
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
                        .tint(Color.accentColor)
                        .buttonBorderShape(.capsule)
                    }
                    .frame(width: 80, alignment: .trailing)
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    ExerciseView(
        exercise: .init(
            id: 0,
            word: .init(
                id: 0,
                text: "pen",
                phonemes: [
                    .init(id: 0, ipa: "p", respelling: "p"),
                    .init(id: 1, ipa: "e", respelling: "e"),
                    .init(id: 2, ipa: "n", respelling: "n")
                ]
            )
        ),
        prevExercise: {},
        nextExercise: {},
        isFirst: false,
        isLast: false
    )
}
