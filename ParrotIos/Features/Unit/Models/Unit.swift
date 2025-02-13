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

    private enum CodingKeys: String, CodingKey {
        case id, name, description, lessons
    }
    
    // For JSON
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? Int.random(in: 1...1_000_000)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.lessons = try container.decode([Lesson].self, forKey: .lessons)
    }
    
    // Default
    init(id: Int, name: String, description: String, lessons: [Lesson]) {
            self.id = id
            self.name = name
            self.description = description
            self.lessons = lessons
    }
}


