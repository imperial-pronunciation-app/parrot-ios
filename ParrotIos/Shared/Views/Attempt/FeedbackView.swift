//
//  FeedbackView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct FeedbackView: View {
    let feedback: Feedback
    
    @State private var isShowingSheet: Bool = false

    public var body: some View {
        VStack {
            PhonemeFeedbackView(feedbackPhonemes: feedback.phonemes, underline: true)
                .onTapGesture {
                    isShowingSheet.toggle()
                }
        }
        .sheet(isPresented: $isShowingSheet) {
            DetailedFeedbackSheet(score: feedback.score, feedbackPhonemes: feedback.phonemes)
        }
    }
}
