//
//  Attempt.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

struct AttemptResponse: Codable, Equatable {
    let recordingId: Int
    let score: Int
    let phonemes: [(Phoneme?, Phoneme?)]
    let xpGain: Int
    
    enum CodingKeys: String, CodingKey {
        case recordingId = "recording_id"
        case score
        case phonemes
        case xpGain = "xp_gain"
    }
    
    init(recordingId: Int, score: Int, phonemes: [(Phoneme?, Phoneme?)], xpGain: Int) {
        self.recordingId = recordingId
        self.score = score
        self.phonemes = phonemes
        self.xpGain = xpGain
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.recordingId = try container.decode(Int.self, forKey: .recordingId)
        self.score = try container.decode(Int.self, forKey: .score)
        self.xpGain = try container.decode(Int.self, forKey: .xpGain)
        
        let phonemeArrays = try container.decode([[Phoneme?]].self, forKey: .phonemes)
        self.phonemes = try phonemeArrays.map { array in
            guard array.count == 2 else {
                throw DecodingError.dataCorruptedError(forKey: .phonemes, in: container, debugDescription: "Expected a phoneme pair, got \(array)")
            }
            return (array[0], array[1])
        }
    }
    
    static func == (lhs: AttemptResponse, rhs: AttemptResponse) -> Bool {
        let phonemesEqual = zip(lhs.phonemes, rhs.phonemes).allSatisfy({ $0 == $1 })
        return phonemesEqual && lhs.recordingId == rhs.recordingId && lhs.score == rhs.score && lhs.xpGain == rhs.xpGain
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(recordingId, forKey: .recordingId)
        try container.encode(score, forKey: .score)
        try container.encode(xpGain, forKey: .xpGain)
        
        let phonemeArrays = phonemes.map { pair in
            [pair.0, pair.1]
        }
        try container.encode(phonemeArrays, forKey: .phonemes)
    }
}
