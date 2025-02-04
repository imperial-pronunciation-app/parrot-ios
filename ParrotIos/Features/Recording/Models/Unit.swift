//
//  Unit.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

import SwiftUI

struct Unit: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let lessons: [Lesson]

    private enum CodingKeys: String, CodingKey {
        case name, description, lessons
    }
}


