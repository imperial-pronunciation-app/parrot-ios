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
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let word = viewModel.word {
                Spacer()
                
                VStack {
                    Text(word.word).font(.largeTitle)
                    Text(word.word_phonemes
                        .compactMap { $0.respelling }
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
                
                Button(action: {
                    Task {
                        await (
                            viewModel.isRecording() ?
                               viewModel.stopRecording() :
                               viewModel.startRecording()
                        )
                    }

                }) {
                    Image(systemName: "mic")
                        .font(.largeTitle)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("No data available.")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRandomWord()
            }
        }
    }
}

#Preview {
    RecordingView()
}
