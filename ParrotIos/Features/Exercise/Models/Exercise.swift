//
//  Excersise.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

struct Exercise: Identifiable, Codable {
    let id: Int
    let word: Word
    let previousExerciseID: Int?
    let nextExerciseID: Int?

    private enum CodingKeys: String, CodingKey {
        case id, word, previousExerciseID = "previous_exercise_id", nextExerciseID = "next_exercise_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.word = try container.decode(Word.self, forKey: .word)
        self.previousExerciseID = try container.decodeIfPresent(Int.self, forKey: .previousExerciseID)
        self.nextExerciseID = try container.decodeIfPresent(Int.self, forKey: .nextExerciseID)
    }
    
    init(id: Int, word: Word, previousExerciseID: Int?, nextExerciseID: Int?) {
        self.id = id
        self.word = word
        self.previousExerciseID = previousExerciseID
        self.nextExerciseID = nextExerciseID
    }
}
