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
    
    private func formatFeedbackPhoneme(_ feedbackPhoneme: (Phoneme?, Phoneme?)) -> Text {
        // expected nil, pronounced not -> said extra phoneme
        // pronounced nil, expected not -> missed phoneme/incorrect
        if let expected = feedbackPhoneme.0 {
            if let pronounced = feedbackPhoneme.1 {
                if expected == pronounced {
                    return Text(expected.respelling).foregroundColor(.green)
                }
            } else {
                return Text(expected.respelling).foregroundColor(.red)
            }
        } else if let pronounced = feedbackPhoneme.1 {
            return Text(pronounced.respelling).foregroundColor(.orange)
        }
        return Text("")
    }
    
    func feedbackView(word: Word, feedbackPhonemes: [(Phoneme?, Phoneme?)], xpGain: Int) -> some View {
        VStack {
            Text(word.text).font(.largeTitle)
            feedbackPhonemes
                .map(formatFeedbackPhoneme)
                .reduce(Text("")) { partialResult, text in
                    if partialResult == Text("") {
                        return text
                    }
                    return partialResult + Text(" ") + text
                }
            .font(.title)
            HStack(spacing: 4) {
                Text("\(xpGain) XP")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("🔥")
            }
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
                UtilComponents.loadingView
            } else if let errorMessage = viewModel.errorMessage {
                UtilComponents.errorView(errorMessage: errorMessage)
            } else if let exercise = viewModel.exercise {
                Spacer()
                VStack(spacing: 32) {
                    if let score = viewModel.score,
                       let feedbackPhonemes = viewModel.feedbackPhonemes,
                       let xpGain = viewModel.xpGain {
                        scoreView(score: score)
                        feedbackView(
                            word: exercise.word,
                            feedbackPhonemes: feedbackPhonemes,
                            xpGain: xpGain)
                    } else {
                        AttemptComponents.wordView(word: exercise.word)
                    }
                }
                Spacer()
                
                HStack {
                    Button(action: { viewModel.playWord() }) {
                        Image(systemName: "speaker.wave.3")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(viewModel.isPlaying ? Color.red.opacity(0.8) : Color.blue)
                            .clipShape(Circle())
                        
                    }
                    
                    Spacer()
                    
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
                    .disabled(viewModel.disableRecording)
                    
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
                }
                .padding(.horizontal, 50)
            }
        }
        .onChange(of: finish) { old, new in
            if new {
                dismiss()
            }
        }
        .task {
            await viewModel.loadExercise()
        }
    }
}


#Preview {
    AttemptView(exerciseId: 1).feedbackView(word: Word(id: 1, text: "mouse", phonemes: [Phoneme(id: 5, ipa: "m'", respelling: "m"), Phoneme(id: 6, ipa: "aʊ", respelling: "ow"), Phoneme(id: 7, ipa: "s", respelling:"s")]), feedbackPhonemes: [(Phoneme(id: 5, ipa: "m'", respelling: "m"), Phoneme(id: 5, ipa: "m'", respelling: "m")), (Phoneme(id: 6, ipa: "aʊ", respelling: "ow"), nil), (nil, Phoneme(id: 7, ipa: "s", respelling:"s"))], xpGain: 5)
}
