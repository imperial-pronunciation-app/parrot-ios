//
//  RecordingView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI

struct AttemptView: View {
    @State private var viewModel: ViewModel
    @State private var finish: Bool = false

    @Environment(\.dismiss) private var dismiss

    init(exerciseId: Int) {
        self.viewModel = ViewModel(exerciseId: exerciseId)
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                UtilComponents.loadingView
            } else if let errorMessage = viewModel.errorMessage {
                UtilComponents.errorView(errorMessage: errorMessage)
            } else if let exercise = viewModel.exercise {
                Spacer()
                VStack(spacing: 32) {
                    if let score = viewModel.score,
                       let feedbackPhonemes = viewModel.feedbackPhonemes,
                       let xpGain = viewModel.xpGain {
                        ScoreView(score: score)
                            .padding(.horizontal, 128)
                        FeedbackView(
                            score: score,
                            word: exercise.word,
                            feedbackPhonemes: feedbackPhonemes,
                            xpGain: xpGain)
                    } else {
                        WordView(word: exercise.word)
                    }
                }
                Spacer()

                HStack {
                    Button(action: { viewModel.playWord() }) {
                        Image(systemName: "speaker.wave.3")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(viewModel.isPlaying ? Color.red.opacity(0.8) : Color.blue)
                            .clipShape(Circle())
                    }

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
                            .background(viewModel.isRecording ? Color.red.opacity(0.8) : Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.disableRecording)

                    Spacer()

                    Button(action: {
                        Task {
                            await viewModel.fetchNextExercise(finish: $finish)
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
                .padding(.horizontal, 50)
            }
        }
        .onChange(of: finish) { _, new in
            if new {
                dismiss()
            }
        }
        .task {
            await viewModel.loadExercise()
        }
    }
}
