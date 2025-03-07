//
//  RecordingButton.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 28/02/2025.
//

import SwiftUI

struct RecordingButton: View {
    var isRecording: Bool
    var isLoading: Bool
    var action: () async -> Void
    @State private var buttonSize: CGFloat = 1
    @State private var gestureStarted = false
    @State private var rotation = 0.0
    @State private var timer: Timer? = nil
    
    private let BUTTON_SIZE: CGFloat = 80
    private let BUTTON_FRAME: CGFloat = 100
    private let LOADING_LINE_WIDTH: CGFloat = 6

    var body: some View {
        if isLoading {
            ZStack {
                // Background circle for context
                Circle()
                    .fill(Color(white: 0.95))
                    .frame(width: BUTTON_SIZE, height: BUTTON_SIZE)
                
                // Animated spinner using a trimmed circle
                Circle()
                    .trim(from: 0.0, to: 0.7)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color.accent, Color.accent.opacity(0.5)]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: LOADING_LINE_WIDTH, lineCap: .round)
                    )
                    .frame(width: BUTTON_SIZE - (LOADING_LINE_WIDTH / 2), height: BUTTON_SIZE - (LOADING_LINE_WIDTH / 2))
                    .rotationEffect(Angle(degrees: rotation))
                    .onAppear {
                        // Invalidate any existing timer first
                        timer?.invalidate()
                        
                        // Reset rotation to ensure consistent starting position
                        rotation = 0
                        
                        // Create a new timer
                        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                            rotation += 3.6 // 360 degrees in 1 second
                            if rotation >= 360 {
                                rotation = 0
                            }
                        }
                        if let timer = timer {
                            RunLoop.current.add(timer, forMode: .common)
                        }
                    }
                    .onDisappear {
                        // Make sure to invalidate the timer when the view disappears
                        timer?.invalidate()
                        timer = nil
                    }
            }
            .frame(width: BUTTON_FRAME, height: BUTTON_FRAME)
        } else {
            Button(action: {}) {
                Image(systemName: "mic")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(width: BUTTON_SIZE, height: BUTTON_SIZE)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                    .scaleEffect(buttonSize)
                    .animation(.easeInOut(duration: 0.2), value: buttonSize)
                    .frame(width: BUTTON_FRAME, height: BUTTON_FRAME)
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
}
