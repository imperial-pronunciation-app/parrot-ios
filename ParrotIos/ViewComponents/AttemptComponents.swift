//
//  AttemptComponents.swift
//  ParrotIos
//
//  Created by Henry Yu on 20/2/2025.
//

import Foundation
import SwiftUI

struct AttemptComponents {
    
    public static func wordView(word: Word) -> some View {
        VStack {
            Text(word.text).font(.largeTitle)
            Text(word.phonemes
                .compactMap { $0.respelling }
                .joined(separator: "."))
            .font(.title)
            .foregroundColor(Color.gray)
        }
    }
    
    public static func formatFeedbackPhoneme(_ feedbackPhoneme: (Phoneme?, Phoneme?)) -> Text {
        // expected nil, pronounced not -> said extra phoneme
        // pronounced nil, expected not -> missed phoneme/incorrect
        if let expected = feedbackPhoneme.0 {
            if let pronounced = feedbackPhoneme.1 {
                if expected == pronounced {
                    return Text(expected.respelling).foregroundColor(.green)
                }
            } else {
                return Text(expected.respelling).foregroundColor(.red)
            }
        } else if let pronounced = feedbackPhoneme.1 {
            return Text(pronounced.respelling).foregroundColor(.orange)
        }
        return Text("")
    }
    
    public static func feedbackView(word: Word, feedbackPhonemes: [(Phoneme?, Phoneme?)], xpGain: Int) -> some View {
        VStack {
            Text(word.text).font(.largeTitle)
            feedbackPhonemes
                .map(formatFeedbackPhoneme)
                .reduce(Text("")) { partialResult, text in
                    if partialResult == Text("") {
                        return text
                    }
                    return partialResult + Text(" ") + text
                }
            .font(.title)
            HStack(spacing: 4) {
                Text("\(xpGain) XP")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("🔥")
            }
        }
    }
    
    public static func scoreView(score: Int) -> some View {
        VStack {
            Text("\(score)%")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            ProgressView(value: Float(score) / 100.0)
                .padding(.horizontal, 128)
        }
    }
}
