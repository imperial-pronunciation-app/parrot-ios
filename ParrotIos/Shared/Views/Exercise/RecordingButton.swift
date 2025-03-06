//
//  RecordingButton.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 28/02/2025.
//

import SwiftUI

struct RecordingButton: View {
    var isRecording: Bool
    var action: () async -> Void
    @State private var buttonSize: CGFloat = 1

    var body: some View {
        Button(action: {}) {
            Image(systemName: "mic")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(Color.accentColor)
                .clipShape(Circle())
                .scaleEffect(buttonSize)
                .animation(.easeInOut(duration: 0.2), value: buttonSize)
                .frame(width: 100, height: 100)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    Task {
                        await action()
                        buttonSize = 1.2
                    }
                }
                .onEnded { _ in
                    Task {
                        await action()
                        buttonSize = 1
                    }
                }
        )
    }
}
