//
//  ScoreView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct ScoreView: View {
    private var viewModel: ViewModel

    init(score: Int) {
        self.viewModel = ViewModel(score: score)
    }

    public var body: some View {
        VStack {
            Text("\(viewModel.score)%")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)

            ProgressView(value: Float(viewModel.score) / 100.0)
                .tint(viewModel.colour)
        }.onAppear {
            UtilComponents.triggerHaptics(haptics: viewModel.haptics)
        }
    }
}
