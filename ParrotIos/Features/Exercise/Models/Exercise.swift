//
//  Excersise.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

struct Exercise: Identifiable, Codable {
    let id = UUID()
    let word: Word
    let previousExerciseID: Int?
    let nextExerciseID: Int?

    private enum CodingKeys: String, CodingKey {
        case word, previousExerciseID = "previous_exercise_id", nextExerciseID = "next_exercise_id"
    }
}
