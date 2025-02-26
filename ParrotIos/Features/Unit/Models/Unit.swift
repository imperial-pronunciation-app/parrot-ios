//
//  Unit.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

import SwiftUI

struct Unit: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let description: String
    let lessons: [Lesson]?
    let recapLesson: Lesson?
    var isCompleted: Bool
    var isLocked: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case lessons
        case recapLesson = "recap_lesson"
        case isCompleted = "is_completed"
        case isLocked = "is_locked"
    }
}
