//
//  Lesson.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 26/02/2025.
//

struct Lesson: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let exerciseIds: [Int]
    let currentExerciseIndex: Int

    private enum CodingKeys: String, CodingKey {
        case id, title, currentExerciseIndex = "current_exercise_index", exerciseIds = "exercise_ids"
    }
}
