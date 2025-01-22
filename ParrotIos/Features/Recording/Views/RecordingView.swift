//
//  RecordingView.swift
//  ParrotIos
//
//  Created by Kyle Lee (https://www.kiloloco.com/articles/023-aws-amplify-storage-with-audio-files/)
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
                        
            Button(action: {
                viewModel.audioRecorder.isRecording ?
                    viewModel.audioRecorder.stopRecording() :
                    viewModel.audioRecorder.startRecording();
            }) {
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
