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
        Button(action: {}) {
            Image(systemName: "mic")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(isRecording ? Color.red.opacity(0.8) : Color.accentColor)
                .clipShape(Circle())
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    Task {
                        await action()
                    }
                }
                .onEnded { _ in
                    Task {
                        await action()
                    }
                }
        )
        .disabled(isDisabled)
    }
}
