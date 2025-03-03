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

    var body: some View {
        VStack {
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
