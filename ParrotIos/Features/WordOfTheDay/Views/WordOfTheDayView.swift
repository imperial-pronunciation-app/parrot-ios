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
                Text("🗓️ Word of the Day")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                Text(Date.now.formatted(date: .long, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                Text("No audio demo for you, challenge yourself!")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                VStack(spacing: 32) {
                    if let score = viewModel.score,
                       let feedbackPhonemes = viewModel.feedbackPhonemes,
                       let xpGain = viewModel.xpGain {
                        AttemptComponents.scoreView(score: score)
                        AttemptComponents.feedbackView(
                            word: word,
                            feedbackPhonemes: feedbackPhonemes,
                            xpGain: xpGain)
                    } else {
                        AttemptComponents.wordView(word: word)
                    }
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
                .padding(.bottom, 20)
            }
        }
        .task {
            await viewModel.loadWordOfTheDay()
        }
    }
}
