//
//  RecordingView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI

struct RecordingView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: 128) {
            Spacer()
            
            VStack {
                Text(viewModel.word).font(.largeTitle)
                Text(viewModel.phonemes
                        .compactMap { $0["respelling"] }
                        .joined(separator: "."))
                    .font(.title)
                    .foregroundColor(Color.gray)
            }
                        
            Button(action: {}) {
                Image(systemName: "speaker.2")
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .buttonBorderShape(.capsule)
            .controlSize(.extraLarge)
                        
            Button(action: {}) {
                Image(systemName: "mic")
                    .font(.largeTitle)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }
}

#Preview {
    RecordingView()
}
