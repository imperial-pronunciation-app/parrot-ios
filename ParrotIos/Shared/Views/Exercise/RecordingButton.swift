//
//  RecordingButton.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 28/02/2025.
//

import SwiftUI

struct RecordingButton: View {
    var isRecording: Bool
    var isDisabled: Bool
    var action: () async -> Void

    var body: some View {
        Button(action: {
            if isRecording {
                Task {
                    await action()
                }
            }
        }) {
            Image(systemName: "mic")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(isRecording ? Color.red.opacity(0.8) : Color.accentColor)
                .clipShape(Circle())
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.1).onEnded { _ in
                Task {
                    await action()
                }
            }
        )
        .disabled(isDisabled)
    }
}
