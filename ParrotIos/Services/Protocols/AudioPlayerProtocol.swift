//
//  AudioPlayerProtocol.swift
//  ParrotIos
//
//  Created by et422 on 14/02/2025.
//

protocol AudioPlayerProtocol {

    func play(word: String, rate: Float, language: String)

    func stop()
}

extension AudioPlayerProtocol {
    func play(word: String, rate: Float) {
        play(word: word, rate: rate, language: "en-US")
    }
}
