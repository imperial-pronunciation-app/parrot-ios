//
//  Attempt.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

struct AttemptResponse: Codable, Equatable {
    let recording_id: Int
    let score: Int
    let recording_phonemes: [Phoneme]
    let xp_gain: Int
}
