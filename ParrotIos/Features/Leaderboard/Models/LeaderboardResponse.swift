//
//  LeaderboardResponse.swift
//  ParrotIos
//
//  Created by Tom Smail on 03/02/2025.
//

import Foundation

struct LeaderboardResponse: Codable, Equatable  {
    let league: String
    let daysUntilEnd: Int
    let leaders: [User]
    let userPosition: [User]
    
    private enum CodingKeys: String, CodingKey {
        case league, daysUntilEnd = "days_until_end", leaders, userPosition = "user_position"
    }
}
