//
//  LeaderboardUser.swift
//  ParrotIos
//
//  Created by Tom Smail on 30/01/2025.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    let username: String
    let xp: Int
}

