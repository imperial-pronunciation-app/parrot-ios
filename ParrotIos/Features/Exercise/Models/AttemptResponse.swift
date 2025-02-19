//
//  Attempt.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

struct AttemptResponse: Codable, Equatable {
    let recordingId: Int
    let score: Int
    let phonemes: [PhonemePair]
    let xpGain: Int
    
    enum CodingKeys: String, CodingKey {
        case recordingId = "recording_id"
        case score
        case phonemes
        case xpGain = "xp_gain"
    }
}

struct PhonemePair: Codable, Equatable {
    let first: Phoneme?
    let second: Phoneme?
    
    enum CodingKeys: Int, CodingKey {
        case first = 0
        case second = 1
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        first = try container.decodeIfPresent(Phoneme.self, forKey: .first)
        second = try container.decodeIfPresent(Phoneme.self, forKey: .second)
    }
}
