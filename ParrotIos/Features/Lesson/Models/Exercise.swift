//
//  Exercise.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

struct Exercise: Identifiable, Codable, Equatable {
    let id: Int
    let word: Word
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case id, word, isCompleted = "is_completed"
    }
}
