//
//  WordOfTheDayView.swift
//  ParrotIos
//
//  Created by Henry Yu on 20/2/2025.
//

import SwiftUI

struct WordOfTheDayView: View {

    @State private var viewModel: ViewModel

    init(viewModel: ViewModel = ViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                UtilComponents.loadingView
            } else if let errorMessage = viewModel.errorMessage {
                UtilComponents.errorView(errorMessage: errorMessage)
            } else if let word = viewModel.word {
                Spacer()
                VStack(spacing: 32) {
                    if let score = viewModel.score {
                        AttemptComponents.scoreView(score: score)
                        AttemptComponents.feedbackView(
                            word: word,
                            goldPhonemes: word.phonemes,
                            recordingPhonemes: viewModel.recording_phonemes!,
                            xp_gain: viewModel.xp_gain!)
                    } else {
                        AttemptComponents.wordView(word: word)
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
                }
                .padding(.horizontal, 50)
            }
        }
        .task {
            await viewModel.loadWordOfTheDay()
        }
    }
}
