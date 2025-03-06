//
//  ScoreView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 05/03/2025.
//

import SwiftUI
import Foundation

extension ScoreView {
    @Observable
    class ViewModel {
        let score: Int

        let low = 25
        let high = 75

        var colour: Color {
            if score < low {
                return .red
            } else if score < high {
                return .orange
            } else {
                return .green
            }
        }

        var haptics: UINotificationFeedbackGenerator.FeedbackType {
            if score < low {
                return .error
            } else if score < high {
                return .warning
            } else {
                return .success
            }
        }

        init(score: Int) {
            self.score = score
        }
    }
}
