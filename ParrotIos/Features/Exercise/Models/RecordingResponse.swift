//
//  RecordingResponse.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

struct RecordingResponse: Codable {
    let recording_id: Int
    let score: Int
    let recording_phonemes: [Phoneme]
    let xp_gain: Int
}
