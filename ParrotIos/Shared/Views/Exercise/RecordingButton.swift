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
    @State private var gestureStarted = false

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
                    if !gestureStarted {
                        gestureStarted = true
                        Task {
                            await action()
                        }
                        withAnimation(.easeInOut(duration: 0.2)) {
                            buttonSize = 1.2
                        }
                    }
                }
                .onEnded { _ in
                    if gestureStarted {
                        Task {
                            await action()
                        }
                        withAnimation(.easeInOut(duration: 0.2)) {
                            buttonSize = 1
                        }
                        gestureStarted = false
                    }
                }
                )
    }
}
