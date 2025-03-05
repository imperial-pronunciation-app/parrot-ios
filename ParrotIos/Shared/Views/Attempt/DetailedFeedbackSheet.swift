//
//  DetailedFeedbackSheet.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct DetailedFeedbackSheet: View {
    @Environment(\.dismiss) private var dismiss

    let score: Int
    let feedbackPhonemes: [(Phoneme?, Phoneme?)]

    public var body: some View {
        NavigationStack {
            VStack {
                DetailedFeedbackView(score: score, phonemes: feedbackPhonemes)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
            }
        }
    }
}
