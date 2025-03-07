//
//  Feedback.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 07/03/2025.
//

struct Feedback: Codable, Equatable {
    let recordingId: Int
    let score: Int
    let phonemes: [(Phoneme?, Phoneme?)]
    let xpGain: Int
    let xpStreakBoost: Int

    enum CodingKeys: String, CodingKey {
        case recordingId = "recording_id"
        case score
        case phonemes
        case xpGain = "xp_gain"
        case xpStreakBoost = "xp_streak_boost"
    }

    init(
        recordingId: Int,
        score: Int,
        phonemes: [(Phoneme?, Phoneme?)],
        xpGain: Int,
        xpStreakBoost: Int
    ) {
        self.recordingId = recordingId
        self.score = score
        self.phonemes = phonemes
        self.xpGain = xpGain
        self.xpStreakBoost = xpStreakBoost
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.recordingId = try container.decode(Int.self, forKey: .recordingId)
        self.score = try container.decode(Int.self, forKey: .score)
        self.xpGain = try container.decode(Int.self, forKey: .xpGain)
        self.xpStreakBoost = try container.decode(Int.self, forKey: .xpStreakBoost)
        self.phonemes = try AttemptDecoding.decodePhonemePairs(from: container, forKey: .phonemes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(recordingId, forKey: .recordingId)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(xpGain, forKey: .xpGain)
        try container.encodeIfPresent(xpStreakBoost, forKey: .xpStreakBoost)

        let phonemeArrays = phonemes.map { pair in [pair.0, pair.1] }
        try container.encodeIfPresent(phonemeArrays, forKey: .phonemes)
    }

    static func == (lhs: Feedback, rhs: Feedback) -> Bool {
        let phonemesEqual = zip(lhs.phonemes, rhs.phonemes).allSatisfy({ $0 == $1 })
        return phonemesEqual &&
               lhs.recordingId == rhs.recordingId &&
               lhs.score == rhs.score &&
               lhs.xpGain == rhs.xpGain &&
               lhs.xpStreakBoost == rhs.xpStreakBoost
    }
}
