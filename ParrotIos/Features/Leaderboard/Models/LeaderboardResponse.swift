//
//  LeaderboardResponse.swift
//  ParrotIos
//
//  Created by Tom Smail on 03/02/2025.
//

import Foundation

struct LeaderboardResponse: Codable  {
    let league: String
    let days_until_end: Int
    let leaders: [User]
    let current: [User]
}
