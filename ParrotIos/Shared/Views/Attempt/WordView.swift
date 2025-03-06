//
//  WordView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct WordView: View {
    let word: Word
    let score: Int?
    let feedbackPhonemes: [(Phoneme?, Phoneme?)]?
    let xpGain: Int?
    let success: Bool?

    func getHaptics() -> UINotificationFeedbackGenerator.FeedbackType? {
        if let success = success, !success {
            return .error
        } else {
            return nil
        }
    }

    var body: some View {
        VStack {
            if let success = success, !success {
                HStack {
                    Image(systemName: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90")
                    Text("Sorry, I didn't get that...")
                }
                .foregroundStyle(.red)
                .padding(.bottom, 4)

                Text("Please try again")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 32)
            }

            if let xpGain = xpGain {
                XpGainView(xpGain: xpGain)
                    .padding(.bottom, 32)
            }

            if let score = score {
                ScoreView(score: score)
                    .padding(.horizontal, 128)
            }
            Text(word.text).font(.largeTitle)
            if let score = score,
               let feedbackPhonemes = feedbackPhonemes,
               let xpGain = xpGain {
                FeedbackView(
                    score: score,
                    word: word,
                    feedbackPhonemes: feedbackPhonemes,
                    xpGain: xpGain
                )
            } else {
                Text(word.phonemes
                    .compactMap { $0.respelling }
                    .joined(separator: "."))
                .font(.title)
                .foregroundColor(Color.gray)
            }
        }.onAppear {
            UtilComponents.triggerHaptics(haptics: getHaptics())
        }
    }
}

#Preview {
    WordView(word: .init(id: 1, text: "foo", phonemes: []), score: 0, feedbackPhonemes: [], xpGain: 10, success: false)
}
