//
//  AudioSynthesizer.swift
//  ParrotIos
//
//  Created by jn1122 on 07/02/2025.
//

import AVFoundation

class AudioSynthesizer: AudioSynthesizerProtocol {
    private let synthesizer: AVSpeechSynthesizer

    init() {
        self.synthesizer = AVSpeechSynthesizer()
    }

    func play(word: String, rate: Float, language: String = "en-US") {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [])
        let utterance = AVSpeechUtterance(string: word)

        let voices = AVSpeechSynthesisVoice.speechVoices()
        let preferredVoice = voices.first { voice in
            voice.language.starts(with: language) && voice.quality == .enhanced
        }

        utterance.voice = preferredVoice ?? AVSpeechSynthesisVoice(language: language)

        utterance.rate = rate

        synthesizer.speak(utterance)
    }

    func stop() {
        // This function does not have to be called, it is optional if early stopping
        synthesizer.stopSpeaking(at: .immediate)
    }
}
