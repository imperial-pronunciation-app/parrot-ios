//
//  LeaderboardViewModel.swift
//  ParrotIos
//
//  Created by Tom Smail on 30/01/2025.
//

import Foundation
import Combine


extension LeaderboardView {
    @Observable
    class ViewModel {
        private(set) var currentUsers: [User] = []
        private(set) var topUsers: [User] = []
        private(set) var league: String?
        private(set) var daysProgress: (current: Int, total: Int) = (0, 7)
        
        private let parrotApi = ParrotApiService()
        
        init() {
            Task {
                await loadLeaderboard()
            }
        }
        
        func loadLeaderboard() async {
    //        var leaderboardResponse = await parrotApi.getLeaderboard()
    //
    //        switch leaderboardResponse {
    //        case .failure(let error):
    //            print("Error fetching leaderboard: \(error)")
    //        case .success(let leaderboardResponse):
    //            topUsers = leaderboardResponse.leaders
    //            currentUsers = leaderboardResponse.currentUsers
    //            league = leaderboardResponse.league
    //            daysProgress = (7 - leaderboardResponse.days_until_end, 7)
    //        }
            
            topUsers = [User(rank: 1, username: "Pedro", xp: 500),
                            User(rank: 2, username: "Jackie", xp: 400),
                            User(rank: 3, username: "James", xp: 350)
                            ]
            currentUsers = [User(rank: 4, username: "Euan", xp: 100),
                            User(rank: 5, username: "Henry", xp: 100),
                            User(rank: 6, username: "Tom2", xp: 100),
                            User(rank: 7, username: "Tom", xp: 100),
                            User(rank: 8, username: "Nikolai", xp: 100)
            ]
            league = "Gold"
            daysProgress = (4, 7)
        }
        
        func envigoratingMessage() -> String {
            if daysProgress.current <= 3 {
                "You've got this! 💪"
            } else if daysProgress.current <= 6 {
                "Keep it up!"
            } else {
                "The week's almost up - keep pushing!"
            }
        }
    }
}
