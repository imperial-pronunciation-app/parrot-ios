//
//  MockAudioService.swift
//  ParrotIosTests
//
//  Created by et422 on 14/02/2025.
//

import Foundation

@testable import ParrotIos

struct AudioPlayerMethods {
    static let play = "play"
    static let stop = "stop"
}

class MockAudioPlayer: AudioPlayerProtocol, CallTracking {
    var callCounts: [String: Int] = [:]
    var callArguments: [String: [[Any?]]] = [:]
    var returnValues: [String: [Result<Any?, Error>]] = [:]

    func play(word: String, rate: Float, language: String) {
        recordCall(for: AudioPlayerMethods.play, with: [word, rate, language])
    }

    func stop() {
        recordCall(for: AudioPlayerMethods.stop)
    }
}
