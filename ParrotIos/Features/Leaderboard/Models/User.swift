//
//  LeaderboardUser.swift
//  ParrotIos
//
//  Created by Tom Smail on 30/01/2025.
//

import Foundation

struct User: Codable, Equatable, Identifiable {
    let id: Int
    let rank: Int
    let displayName: String
    let xp: Int
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id
        case rank
        case displayName = "display_name"
        case xp
        case avatar
    }
}
