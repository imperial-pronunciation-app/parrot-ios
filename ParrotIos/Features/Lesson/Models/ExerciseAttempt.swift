//
//  Attempt.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

struct ExerciseAttempt: Codable, Equatable {
    let recordingId: Int?
    let score: Int?
    let phonemes: [(Phoneme?, Phoneme?)]?
    let xpGain: Int?
    let exerciseIsCompleted: Bool?
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case recordingId = "recording_id"
        case score
        case phonemes
        case xpGain = "xp_gain"
        case exerciseIsCompleted = "exercise_is_completed"
        case success
    }

    init(
        success: Bool,
        recordingId: Int?,
        score: Int?,
        phonemes: [(Phoneme?, Phoneme?)]?,
        xpGain: Int?,
        exerciseIsCompleted: Bool?
    ) {
        self.success = success
        self.recordingId = recordingId
        self.score = score
        self.phonemes = phonemes
        self.xpGain = xpGain
        self.exerciseIsCompleted = exerciseIsCompleted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.recordingId = try container.decodeIfPresent(Int.self, forKey: .recordingId)
        self.score = try container.decodeIfPresent(Int.self, forKey: .score)
        self.xpGain = try container.decodeIfPresent(Int.self, forKey: .xpGain)
        self.phonemes = try AttemptDecoding.decodePhonemePairsIfPresent(from: container, forKey: .phonemes)
        self.exerciseIsCompleted = try container.decodeIfPresent(Bool.self, forKey: .exerciseIsCompleted)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encodeIfPresent(recordingId, forKey: .recordingId)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(xpGain, forKey: .xpGain)

        let phonemeArrays = phonemes.map { $0.map { pair in [pair.0, pair.1] } }
        try container.encodeIfPresent(phonemeArrays, forKey: .phonemes)
        try container.encodeIfPresent(exerciseIsCompleted, forKey: .exerciseIsCompleted)
    }

    static func == (lhs: ExerciseAttempt, rhs: ExerciseAttempt) -> Bool {
        let phonemesEqual = zip(lhs.phonemes ?? [], rhs.phonemes ?? []).allSatisfy({ $0 == $1 })
        return phonemesEqual &&
               lhs.recordingId == rhs.recordingId &&
               lhs.score == rhs.score &&
               lhs.xpGain == rhs.xpGain &&
               lhs.exerciseIsCompleted == rhs.exerciseIsCompleted &&
               lhs.success == rhs.success
    }
}
