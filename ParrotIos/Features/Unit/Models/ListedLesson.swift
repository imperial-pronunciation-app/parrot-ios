//
//  ListedLesson.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

struct ListedLesson: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let isCompleted: Bool
    let isLocked: Bool
    let stars: Int?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted = "is_completed"
        case isLocked = "is_locked"
        case stars
    }

    // Default
    init(id: Int, title: String, isCompleted: Bool, isLocked: Bool, stars: Int? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.stars = stars
    }
}
