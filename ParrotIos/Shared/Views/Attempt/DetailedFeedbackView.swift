//
//  DetailedFeedbackView.swift
//  ParrotIos
//
//  Created by James Watling on 27/02/2025.
//

import SwiftUI

struct DetailedFeedbackView: View {
    let score: Int
    let phonemes: [(Phoneme?, Phoneme?)]

    var body: some View {
        VStack {
            ScoreView(score: score)
                .padding(.horizontal, 84)
            PhonemeFeedbackView(feedbackPhonemes: phonemes, underline: false)
            VStack(alignment: .leading, spacing: 12) {
                ForEach(phonemes.indices, id: \.self) { phonemesIdx in
                    PhonemeDetailView(phonemes: phonemes[phonemesIdx])
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            Spacer()
        }
    }
}

struct PhonemeDetailView: View {
    let phonemes: (Phoneme?, Phoneme?)

    var body: some View {
        if let expected = phonemes.0 {
            if let pronounced = phonemes.1 {
                if expected == pronounced {
                    PhonemeMiniCard(phoneme: expected)
                } else {
                    HStack {
                        PhonemeMiniCard(phoneme: expected)
                        Text("You said")
                            .foregroundStyle(.red)
                        PhonemeMiniCard(phoneme: pronounced)
                    }
                }
            } else {
                HStack {
                    PhonemeMiniCard(phoneme: expected)
                    Text("You missed this sound")
                        .foregroundStyle(.red)
                }
            }
        } else if let pronounced = phonemes.1 {
            HStack {
                PhonemeMiniCard(phoneme: pronounced, missing: true)
                HStack(spacing: 4) {
                    Image(systemName: "arrow.turn.left.down")
                        .foregroundStyle(.orange)
                    Text("You added this sound")
                        .foregroundStyle(.orange)
                }
            }
        }
    }
}

struct PhonemeMiniCard: View {
    let phonemePlayer = PhonemePlayer()
    let phoneme: Phoneme
    let missing: Bool

    init(phoneme: Phoneme, missing: Bool = false) {
        self.phoneme = phoneme
        self.missing = missing
    }

    var body: some View {
        Button(action: {
            Task {
                await phonemePlayer.play(phoneme: phoneme, rate: 0.5)
            }
        }) {
            HStack(spacing: 2) {
                Image(systemName: phoneme.cdnPath != nil ? "speaker.wave.2" : "speaker.slash.fill")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                Text(phoneme.respelling)
                    .foregroundStyle(missing ? .gray : .primary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .frame(minWidth: 60)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        Color(UIColor.systemGray4),
                        style: missing ? StrokeStyle(lineWidth: 1, dash: [5]) : StrokeStyle(lineWidth: 1)
                    )
            )
        }
        .disabled(phoneme.cdnPath == nil)
    }
}

#Preview {
    DetailedFeedbackView(
        score: 80,
        phonemes: [
            (Phoneme(id: 9, ipa: "s", respelling: "s", cdnPath: ""), Phoneme(id: 3, ipa: "h", respelling: "h", cdnPath: "")),
            (Phoneme(id: 30, ipa: "ɑː", respelling: "ah", cdnPath: ""), Phoneme(id: 30, ipa: "ɑː", respelling: "ah", cdnPath: "")),
            (nil, Phoneme(id: 16, ipa: "d", respelling: "d", cdnPath: "")),
            (Phoneme(id: 23, ipa: "t", respelling: "t", cdnPath: ""), nil)
        ])
}
