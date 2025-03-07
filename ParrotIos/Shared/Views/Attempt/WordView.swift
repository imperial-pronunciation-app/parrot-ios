//
//  WordView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct WordView<Content: View>: View {
    let word: Word
    let feedback: Feedback?
    let success: Bool?
    let customMessage: Content
    
    init(
        word: Word,
        feedback: Feedback?,
        success: Bool?,
        @ViewBuilder customMessage: () -> Content = { EmptyView() }
    ) {
        self.word = word
        self.feedback = feedback
        self.success = success
        self.customMessage = customMessage()
    }

    func getHaptics() -> UINotificationFeedbackGenerator.FeedbackType? {
        if let success = success, !success {
            return .error
        } else {
            return nil
        }
    }

    var body: some View {
        VStack {
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
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 32)
                } else {
                    customMessage
                        .padding(.horizontal, 32)
                }
                
                if let feedback = feedback {
                    XpGainView(xpGain: feedback.xpGain, xpStreakBoost: feedback.xpStreakBoost)
                        .padding(.bottom, 32)
                    
                    ScoreView(score: feedback.score)
                        .padding(.horizontal, 128)
                }
                
            }
            .frame(height: 200)
            Text(word.text).font(.largeTitle)
            if let feedback = feedback {
                FeedbackView(feedback: feedback)
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
    WordView(word: .init(id: 1, text: "foo", phonemes: []), feedback: .init(recordingId: 0, score: 0, phonemes: [], xpGain: 10, xpStreakBoost: 0), success: false)
}
