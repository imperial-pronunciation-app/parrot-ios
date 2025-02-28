//
//  Lesson.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 26/02/2025.
//

struct Lesson: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let exercises: [Exercise]
    let currentExerciseIndex: Int

    private enum CodingKeys: String, CodingKey {
        case id, title, exercises, currentExerciseIndex = "current_exercise_index"
    }
}
