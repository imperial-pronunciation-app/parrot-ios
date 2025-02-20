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
    
    public static func feedbackView(word: Word, goldPhonemes: [Phoneme], recordingPhonemes: [Phoneme], xp_gain: Int) -> some View {
        VStack {
            Text(word.text).font(.largeTitle)
            Text(goldPhonemes
                .compactMap { $0.respelling }
                .joined(separator: "."))
            .font(.title)
            .foregroundColor(.green)
            Text(recordingPhonemes
                .compactMap { $0.respelling }
                .joined(separator: "."))
            .font(.title)
            .foregroundColor(.red)
            HStack(spacing: 4) {
                Text("\(xp_gain) XP")
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
