//
//  WordOfTheDayView.swift
//  ParrotIos
//
//  Created by Henry Yu on 20/2/2025.
//

import SwiftUI

struct WordOfTheDayView: View {

    @State private var viewModel: ViewModel = ViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                UtilComponents.loadingView
            } else if let errorMessage = viewModel.errorMessage {
                UtilComponents.errorView(errorMessage: errorMessage)
            } else if let word = viewModel.word {
                Text("Word of the Day")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 4)
                Text(Date.now.formatted(date: .long, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                WordView(
                    word: word,
                    score: viewModel.score,
                    feedbackPhonemes: viewModel.feedbackPhonemes,
                    xpGain: viewModel.xpGain,
                    xpStreakBoost: viewModel.xpStreakBoost,
                    success: viewModel.success
                )

                Spacer()

                AudioButton(isDisabled: true, action: {})

                Text("Challenge: Say it without hearing it!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 8)

                Spacer()

                RecordingButton(
                    isRecording: viewModel.isRecording,
                    isLoading: viewModel.awaitingFeedback,
                    action: viewModel.toggleRecording
                ).padding()
            }
        }
        .task {
            await viewModel.loadWordOfTheDay()
        }
    }
}
