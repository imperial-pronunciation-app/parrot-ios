//
//  AudioButton.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 28/02/2025.
//

import SwiftUI

struct AudioButton: View {
    var isDisabled: Bool
    var action: () -> Void

    init(isDisabled: Bool = false, action: @escaping () -> Void) {
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: isDisabled ? {} : action) {
            Image(systemName: isDisabled ? "speaker.slash.fill" : "speaker.wave.3")
                .font(.title3)
                .frame(width: 48, height: 48)
        }
        .buttonStyle(.bordered)
        .tint(isDisabled ? .gray : .accentColor)
        .clipShape(Circle())
        .disabled(isDisabled)
    }
}
