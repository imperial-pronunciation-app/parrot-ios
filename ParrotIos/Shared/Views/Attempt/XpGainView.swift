//
//  XpGainView.swift
//  ParrotIos
//
//  Created by James Watling on 03/03/2025.
//

import SwiftUI

struct XpGainView: View {
    let xpGain: Int
    let xpStreakBoost: Int

    @State private var showBase = false
    @State private var showStreak = false
    @State private var showTotal = false

    @State private var baseOpacity: Double = 0
    @State private var baseScale: CGFloat = 0.6

    @State private var streakOpacity: Double = 0
    @State private var streakScale: CGFloat = 0.6

    @State private var totalOpacity: Double = 0
    @State private var totalScale: CGFloat = 0.6

    private var totalXp: Int {
        xpGain + xpStreakBoost
    }

    var body: some View {
        VStack(spacing: 8) {

            if xpStreakBoost > 0, showStreak {
                XpLabelView(
                    iconName: "flame.fill",
                    xpValue: xpStreakBoost,
                    color: .red,
                    backgroundColor: .red.opacity(0.2),
                    scale: streakScale,
                    opacity: streakOpacity
                )
            }

            if xpStreakBoost > 0, showTotal {
                XpLabelView(
                    iconName: "bolt.fill",
                    xpValue: totalXp,
                    color: .orange,
                    backgroundColor: .yellow.opacity(0.2),
                    scale: totalScale,
                    opacity: totalOpacity
                )
            }

            if xpGain > 0, showBase {
                XpLabelView(
                    iconName: "bolt.fill",
                    xpValue: xpGain,
                    color: .orange,
                    backgroundColor: .yellow.opacity(0.2),
                    scale: baseScale,
                    opacity: baseOpacity
                )
            }
        }
        .frame(height: 120)
        .onAppear {
            animateSequence()
        }
    }

    private func animateSequence() {
        let initialDelay: Double = 0.5
        let springAnimation = Animation.interpolatingSpring(stiffness: 150, damping: 10)
        let settleAnimation = Animation.interpolatingSpring(stiffness: 150, damping: 12)

        // Animate Base XP
        if xpGain > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
                showBase = true
                withAnimation(springAnimation) {
                    baseOpacity = 1
                    baseScale = 1.25
                }
                withAnimation(settleAnimation.delay(0.1)) {
                    baseScale = 1
                }
            }
        }

        // Animate Streak Boost
        if xpStreakBoost > 0 {
            let streakDelay = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay + streakDelay) {
                showStreak = true
                withAnimation(springAnimation) {
                    streakOpacity = 1
                    streakScale = 1.25
                }
                withAnimation(settleAnimation.delay(0.1)) {
                    streakScale = 1
                }

                let totalDelay = 0.9
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
                    withAnimation(.easeInOut) {
                        showBase = false
                        showStreak = false
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showTotal = true
                        withAnimation(springAnimation) {
                            totalOpacity = 1
                            totalScale = 1.35
                        }
                        withAnimation(settleAnimation.delay(0.2)) {
                            totalScale = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        }
                    }
                }
            }
        }
    }
}

struct XpLabelView: View {
    let iconName: String
    let xpValue: Int
    let color: Color
    let backgroundColor: Color
    let scale: CGFloat
    let opacity: Double

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.body)
                .foregroundStyle(color)
            Text("\(xpValue) XP")
                .foregroundStyle(color)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(backgroundColor)
        .cornerRadius(6)
        .scaleEffect(scale)
        .opacity(opacity)
        .transition(.scale.combined(with: .opacity))  // Smooth enter/exit
    }
}
