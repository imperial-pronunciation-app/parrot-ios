//
//  PhonemeFeedbackView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct PhonemeFeedbackView: View {
    let feedbackPhonemes: [(Phoneme?, Phoneme?)]
    let underline: Bool

    public var body: some View {
        HStack {
            ForEach(feedbackPhonemes.indices, id: \.self) { feedbackPhonemeId in
                let feedbackPhoneme = feedbackPhonemes[feedbackPhonemeId]
                if let expected = feedbackPhoneme.0 {
                    if let pronounced = feedbackPhoneme.1 {
                        if expected == pronounced {
                            Text(expected.respelling)
                                .foregroundColor(.green)
                                .font(.title)
                                .underline(underline)
                        } else {
                            Text(expected.respelling)
                                .foregroundColor(.red)
                                .font(.title)
                                .underline(underline)
                        }
                    } else {
                        Text(expected.respelling)
                            .foregroundColor(.red)
                            .font(.title)
                            .underline(underline)
                    }
                } else if feedbackPhoneme.1 != nil {
                    Image(systemName: "arrow.turn.left.down").foregroundStyle(.orange)
                        .offset(y: -5)
                        .font(.title3)
                }
            }
        }
    }
}
