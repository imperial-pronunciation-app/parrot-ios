//
//  AudioPlayer.swift
//  ParrotIos
//
//  Created by jn1122 on 07/02/2025.
//

import AVFoundation

class AudioPlayer: AudioPlayerProtocol {
    private let synthesizer: AVSpeechSynthesizer

    init() {
        self.synthesizer = AVSpeechSynthesizer()
    }

    func play(word: String, rate: Float, language: String = "en-US") {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [])
        let utterance = AVSpeechUtterance(string: word)
        if let maleVoice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoice.speechVoices().first(
            where: { $0.gender == .male && $0.language == "en-US" })?.identifier ?? "") {
            utterance.voice = maleVoice
            utterance.pitchMultiplier = 1.5
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Default fallback
        }
        utterance.rate = rate

        synthesizer.speak(utterance)
    }

    func stop() {
        // This function does not have to be called, it is optional if early stopping
        synthesizer.stopSpeaking(at: .immediate)
    }
}
