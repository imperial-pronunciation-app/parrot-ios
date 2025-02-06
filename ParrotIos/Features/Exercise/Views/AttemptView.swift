//
//  RecordingView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI

struct AttemptView: View {
    @State private var viewModel: ViewModel
    
    init(exerciseId: Int) {
        self.viewModel = ViewModel(exerciseId: exerciseId)
    }
    
    private func wordView(word: Word) -> some View {
        VStack {
            Text(word.text).font(.largeTitle)
            Text(word.phonemes
                .compactMap { $0.respelling }
                .joined(separator: "."))
            .font(.title)
            .foregroundColor(Color.gray)
        }
    }
    
    private func scoreView(score: Int) -> some View {
        VStack {
            Text("\(score)%")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            ProgressView(value: Float(score) / 100.0)
                .padding(.horizontal, 128)
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading...")
            .scaleEffect(1.5, anchor: .center)
            .padding()
    }
    
    private func errorView(errorMessage: String) -> some View {
        VStack {
            Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else if let exercise = viewModel.exercise {
                Spacer()
                VStack(spacing: 32) {
                    if let score = viewModel.score {
                        scoreView(score: score)
                    }
                    wordView(word: exercise.word)
                }
                Spacer()
                
                ZStack {
                    VStack {
                        Button(action: {
                            Task {
                                await viewModel.toggleRecording()
                            }
                        }) {
                            Image(systemName: "mic")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(viewModel.isRecording ? Color.red.opacity(0.8) : Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchNextExercise()
                            }
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .padding(.trailing, 64)
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage: errorMessage)
            }
        }
    }
}
