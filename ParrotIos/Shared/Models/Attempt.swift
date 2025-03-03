//
//  Attempt.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 28/02/2025.
//

struct Attempt: Codable, Equatable {
    let recordingId: Int
    let score: Int
    let phonemes: [(Phoneme?, Phoneme?)]
    let xpGain: Int
    let exerciseIsCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case recordingId = "recording_id"
        case score
        case phonemes
        case xpGain = "xp_gain"
        case exerciseIsCompleted = "exercise_is_completed"
    }

    init(recordingId: Int, score: Int, phonemes: [(Phoneme?, Phoneme?)], xpGain: Int, exerciseIsCompleted: Bool) {
        self.recordingId = recordingId
        self.score = score
        self.phonemes = phonemes
        self.xpGain = xpGain
        self.exerciseIsCompleted = exerciseIsCompleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recordingId = try container.decode(Int.self, forKey: .recordingId)
        self.score = try container.decode(Int.self, forKey: .score)
        self.xpGain = try container.decode(Int.self, forKey: .xpGain)
        self.phonemes = try AttemptDecoding.decodePhonemePairs(from: container, forKey: .phonemes)
        self.exerciseIsCompleted = try container.decode(Bool.self, forKey: .exerciseIsCompleted)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recordingId, forKey: .recordingId)
        try container.encode(score, forKey: .score)
        try container.encode(xpGain, forKey: .xpGain)
        
        let phonemeArrays = phonemes.map { pair in [pair.0, pair.1] }
        try container.encode(phonemeArrays, forKey: .phonemes)
        try container.encode(exerciseIsCompleted, forKey: .exerciseIsCompleted)
    }
    
    static func == (lhs: Attempt, rhs: Attempt) -> Bool {
        let phonemesEqual = zip(lhs.phonemes, rhs.phonemes).allSatisfy({ $0 == $1 })
        return phonemesEqual &&
               lhs.recordingId == rhs.recordingId &&
               lhs.score == rhs.score &&
               lhs.xpGain == rhs.xpGain
    }
}
