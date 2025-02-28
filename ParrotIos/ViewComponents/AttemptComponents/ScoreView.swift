//
//  ScoreView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct ScoreView: View {
    let score: Int
    func getColour() -> Color {
        if score < 25 {
            return .red
        } else if score < 75 {
            return .orange
        } else {
            return .green
        }
    }

    public var body: some View {
        VStack {
            Text("\(score)%")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)

            ProgressView(value: Float(score) / 100.0)
                .tint(getColour())
        }
    }
}
