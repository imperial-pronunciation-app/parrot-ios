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
    let lessons: [Lesson]
    let recapLesson: Lesson?

    private enum CodingKeys: String, CodingKey {
        case id, name, description, lessons, recapLesson = "recap_lesson"
    }
    
    // For JSON
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? Int.random(in: 1...1_000_000)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.lessons = try container.decode([Lesson].self, forKey: .lessons)
        // TODO: Remove
        self.recapLesson = (try? container.decode(Lesson?.self, forKey: .recapLesson)) ?? nil
    }
    
    // Default
    init(id: Int, name: String, description: String, lessons: [Lesson], recapLesson: Lesson?) {
            self.id = id
            self.name = name
            self.description = description
            self.lessons = lessons
            self.recapLesson = recapLesson
    }
}


