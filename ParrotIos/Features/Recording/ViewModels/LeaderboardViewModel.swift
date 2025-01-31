//
//  LeaderboardViewModel.swift
//  ParrotIos
//
//  Created by Tom Smail on 30/01/2025.
//

import Foundation
import Combine


class LeaderboardViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var daysProgress: (current: Int, total: Int) = (0, 7)
    
    private var parrotApi: ParrotApiService
    
    init(parrotApi: ParrotApiService = ParrotApiService()) {
        self.parrotApi = parrotApi
        Task {
            await loadLeaderboard()
            calculateDaysProgress()
        }
    }

    func loadLeaderboard() async {
        let sampleUsers = [
            User(username: "nikolai", xp: 553),
            User(username: "pedro!", xp: 324),
            User(username: "jwatl1ng", xp: 203),
            User(username: "henryu03", xp: 124),
            User(username: "bigDawg", xp: 124)
        ]
        
        // TODO: Swap leaderboard for users 
        var leaderboard = await parrotApi.getLeaderboard()

        users = sampleUsers.sorted { $0.xp > $1.xp }
    }
    
    func calculateDaysProgress() {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: Date())
            
            // Stop Sunday being 1 (Moday is 1)
            let adjustedDay = (weekday == 1) ? 7 : weekday - 1
            daysProgress = (adjustedDay, 7)
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
