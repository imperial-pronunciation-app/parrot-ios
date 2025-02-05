//
//  Lesson.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

struct Lesson: Identifiable, Codable {
    let id: Int
    let title: String
    let currentExerciseID: Int?
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case id, title, currentExerciseID = "current_exercise_id", isCompleted = "is_completed"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.currentExerciseID = try container.decodeIfPresent(Int.self, forKey: .currentExerciseID)
        self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
    
    init(id: Int, title: String, currentExerciseID: Int?, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.currentExerciseID = currentExerciseID
        self.isCompleted = isCompleted
    }
}
