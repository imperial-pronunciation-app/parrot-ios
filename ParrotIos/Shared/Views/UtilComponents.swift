//
//  UtilComponents.swift
//  ParrotIos
//
//  Created by Henry Yu on 20/2/2025.
//

import Foundation
import SwiftUI

struct UtilComponents {

    public static var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    public static func errorView(errorMessage: String) -> some View {
        VStack {
            Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    public static func triggerHaptics(haptics: UINotificationFeedbackGenerator.FeedbackType?) {
        let generator = UINotificationFeedbackGenerator()
        if let haptics = haptics {
            generator.notificationOccurred(haptics)
        }
    }
}
