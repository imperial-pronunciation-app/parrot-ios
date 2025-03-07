//
//  Attempt.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 28/02/2025.
//

struct Attempt: Codable, Equatable {
    let success: Bool
    let feedback: Feedback?


    enum CodingKeys: String, CodingKey {
        case success
        case feedback
    }

    init(
        success: Bool,
        feedback: Feedback?
    ) {
        self.success = success
        self.feedback = feedback
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.success = try container.decode(Bool.self, forKey: .success)
        self.feedback = try container.decodeIfPresent(Feedback.self, forKey: .feedback)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(success, forKey: .success)
        try container.encodeIfPresent(feedback, forKey: .feedback)
    }

    static func == (lhs: Attempt, rhs: Attempt) -> Bool {
        return lhs.success == rhs.success &&
               lhs.feedback == rhs.feedback
    }
}
