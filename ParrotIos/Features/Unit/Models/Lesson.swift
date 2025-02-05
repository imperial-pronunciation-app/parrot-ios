//
//  Lesson.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

struct Lesson: Identifiable, Codable {
    let id = UUID()
    let title: String
    let currentExerciseID: Int?
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case title, currentExerciseID = "current_exercise_id", isCompleted = "is_completed"
    }
}
