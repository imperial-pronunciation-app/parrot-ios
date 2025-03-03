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

    var body: some View {
        VStack {
            if !(success ?? true) {
                Text(
                    "\(Image(systemName: "exclamationmark.arrow.trianglehead.counterclockwise.rotate.90")) Sorry, I didn't get that..."
                )
                    .foregroundStyle(.red)
                    .padding(.bottom, 4)

                Text("Please try again")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
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
        }
    }
}

#Preview {
    WordView(word: .init(id: 1, text: "foo", phonemes: []), score: 0, feedbackPhonemes: [], xpGain: 10, success: false)
}
