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
    let username: String
    let xp: Int
}
