//
//  PhonemeDetailView.swift
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
            AttemptComponents.scoreView(score: score)
                .padding(.horizontal, 84)
            AttemptComponents.phonemeFeedbackView(feedbackPhonemes: phonemes)
            Spacer()
        }
    }
}

Phoneme

#Preview {
    PhonemeDetailView(score: 80, phonemes: [(Phoneme(id: 9, ipa: "s", respelling: "s"), Phoneme(id: 3, ipa: "h", respelling: "h")), (Phoneme(id: 30, ipa: "ɑː", respelling: "ah"), Phoneme(id: 30, ipa: "ɑː", respelling: "ah"))])
}
