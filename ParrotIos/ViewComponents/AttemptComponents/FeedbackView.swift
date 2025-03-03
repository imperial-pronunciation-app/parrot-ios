//
//  FeedbackView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct FeedbackView: View {
    let score: Int
    let word: Word
    let feedbackPhonemes: [(Phoneme?, Phoneme?)]
    let xpGain: Int
    @State private var isShowingSheet: Bool = false

    public var body: some View {
        VStack {
            PhonemeFeedbackView(feedbackPhonemes: feedbackPhonemes, underline: true)
                .onTapGesture {
                    isShowingSheet.toggle()
                }
            HStack(spacing: 4) {
                Text("\(xpGain) XP")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("🔥")
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            DetailedFeedbackSheet(score: score, feedbackPhonemes: feedbackPhonemes)
        }
    }
}
