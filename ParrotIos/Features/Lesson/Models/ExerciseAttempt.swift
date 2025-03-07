//
//  Attempt.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

struct ExerciseAttempt: Codable, Equatable {
    let feedback: Feedback?
    let exerciseIsCompleted: Bool
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case feedback
        case exerciseIsCompleted = "exercise_is_completed"
        case success
    }

    init(
        success: Bool,
        feedback: Feedback?,
        exerciseIsCompleted: Bool
    ) {
        self.success = success
        self.feedback = feedback
        self.exerciseIsCompleted = exerciseIsCompleted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.feedback = try container.decodeIfPresent(Feedback.self, forKey: .feedback)
        self.exerciseIsCompleted = try container.decode(Bool.self, forKey: .exerciseIsCompleted)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encodeIfPresent(feedback, forKey: .feedback)
        try container.encodeIfPresent(exerciseIsCompleted, forKey: .exerciseIsCompleted)
    }

    static func == (lhs: ExerciseAttempt, rhs: ExerciseAttempt) -> Bool {
        return lhs.feedback == rhs.feedback &&
               lhs.exerciseIsCompleted == rhs.exerciseIsCompleted &&
               lhs.success == rhs.success
    }
}
