//
//  RecordingView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI

struct AttemptView: View {
    @State private var viewModel: ViewModel
    @State private var finish: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
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
    
    private func feedbackView(goldPhonemes: [Phoneme], recordingPhonemes: [Phoneme], xp_gain: Int) -> some View {
        VStack(spacing: 10) {
            // Display gold phonemes
            HStack(spacing: 8) {
                ForEach(goldPhonemes.indices, id: \.self) { index in
                        Text(goldPhonemes[index].respelling)
                        .foregroundColor(.green)
                }
            }
            // Display recording phonemes
            HStack(spacing: 8) {
                ForEach(recordingPhonemes.indices, id: \.self) { index in
                    // Bad solution for now, does this match the gold index?
                    let recordingPhoneme = recordingPhonemes[index]
                    let goldPhoneme = index < goldPhonemes.count ? goldPhonemes[index] : nil
                    
                    Text(recordingPhoneme.respelling)
                        .foregroundColor(recordingPhoneme == goldPhoneme ? .green : .red)
                }
            }
            
            HStack(spacing: 4) {
                Text("\(xp_gain) XP")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("🔥")
            }
        }
        .padding()
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
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage: errorMessage)
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
                                await viewModel.fetchNextExercise(finish: $finish)
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
            }
        }
        .onChange(of: finish) { old, new in
            if new {
                dismiss()
            }
        }
    }
}
