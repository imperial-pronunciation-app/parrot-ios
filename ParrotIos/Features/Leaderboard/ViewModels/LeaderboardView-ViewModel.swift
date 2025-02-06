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
            let leaderboardResponse = await parrotApi.getLeaderboard()
    
            switch leaderboardResponse {
            case .failure(let error):
                print("Error fetching leaderboard: \(error)")
            case .success(let leaderboardResponse):
                topUsers = leaderboardResponse.leaders
                currentUsers = leaderboardResponse.current
                league = leaderboardResponse.league
                daysProgress = (7 - leaderboardResponse.days_until_end, 7)
            }
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
