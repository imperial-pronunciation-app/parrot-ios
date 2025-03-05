//
//  XpGainView.swift
//  ParrotIos
//
//  Created by James Watling on 03/03/2025.
//

import SwiftUI

struct XpGainView: View {
    let xpGain: Int
    @State var opacity: Double = 0
    @State var scale: Double = 0.6

    public var body: some View {
        HStack {
            Image(systemName: "bolt.fill")
                .font(.body)
                .foregroundStyle(.orange)
            Text("+ \(xpGain) XP")
                .foregroundStyle(.orange)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.yellow.opacity(0.2))
        .cornerRadius(6)
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            // Phase 1: Fade in and pop a bit above final size
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 10)) {
                opacity = 1
                scale = 1.15
            }
            // Phase 2: Slight delay, then settle back to scale = 1
            withAnimation(.interpolatingSpring(stiffness: 150, damping: 12).delay(0.1)) {
                scale = 1
            }
        }
    }
}

#Preview {
    XpGainView(xpGain: 40)
}
