//
//  UtilComponents.swift
//  ParrotIos
//
//  Created by Henry Yu on 20/2/2025.
//

import Foundation
import SwiftUI

struct UtilComponents {

    public static let loadingView: some View {
        ProgressView("Loading...")
            .scaleEffect(1.5, anchor: .center)
            .padding()
    }

    public static func errorView(errorMessage: String) -> some View {
        VStack {
            Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
