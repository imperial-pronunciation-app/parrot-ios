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

    func play(word: String, rate: Float, language: String = "en-US") {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate

        synthesizer.speak(utterance)
    }

    func stop() {
        // This function does not have to be called, it is optional if early stopping
        synthesizer.stopSpeaking(at: .immediate)
    }
}
