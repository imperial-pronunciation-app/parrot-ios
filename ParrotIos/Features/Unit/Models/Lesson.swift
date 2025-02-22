//
//  Lesson.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

struct Lesson: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let firstExerciseID: Int
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case id, title, firstExerciseID = "first_exercise_id", isCompleted = "is_completed"
    }

    // For JSON
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.firstExerciseID = try container.decode(Int.self, forKey: .firstExerciseID)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }

    // Default
    init(id: Int, title: String, firstExerciseID: Int, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.firstExerciseID = firstExerciseID
        self.isCompleted = isCompleted
    }
}
