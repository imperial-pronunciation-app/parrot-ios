//
//  LeaderboardUser.swift
//  ParrotIos
//
//  Created by Tom Smail on 30/01/2025.
//

import Foundation

struct User: Codable, Equatable {
    let rank: Int
    let displayName: String
    let xp: Int

    enum CodingKeys: String, CodingKey {
        case rank
        case displayName = "display_name"
        case xp
    }
}
