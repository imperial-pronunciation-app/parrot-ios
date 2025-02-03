//
//  AudioPlayer.swift
//  ParrotIos
//
//  Created by Tom Smail on 03/02/2025.
//

import AVFoundation

class AudioPlayer {
    private let synthesizer: AVSpeechSynthesizer

    init() {
        self.synthesizer = AVSpeechSynthesizer()
    }

    func play(phoneme: String, language: String = "en-US", rate: Float = 0.5) {
        let utterance = AVSpeechUtterance(string: phoneme)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate

        synthesizer.speak(utterance)
    }

    func stop() {
        // This function does not have to be called, it is optional if early stopping
        synthesizer.stopSpeaking(at: .immediate)
    }
}
