//
//  XpGainView.swift
//  ParrotIos
//
//  Created by James Watling on 03/03/2025.
//

import SwiftUI

struct XpGainView: View {
    let xpGain: Int

    public var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.body)
                .foregroundStyle(.accent)
            Text("+ \(xpGain) xp")
                .foregroundStyle(.accent)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.accent.opacity(0.2))
        .cornerRadius(6)
    }
}

#Preview {
    XpGainView(xpGain: 40)
}
