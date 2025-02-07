//
//  LeaderboardView.swift
//  ParrotIos
//
//  Created by Tom Smail on 30/01/2025.
//

import SwiftUI

struct LeaderboardView: View {
    
    private let viewModel = ViewModel()
    
    private func weekProgress() -> some View {
        VStack {
            Text("\(self.viewModel.daysProgress.current)/\(self.viewModel.daysProgress.total) days")
                            .font(.subheadline)
                            .foregroundColor(.gray)

            ProgressView(value: Double(self.viewModel.daysProgress.current), total: Double(self.viewModel.daysProgress.total))
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .padding(.horizontal, 40)
            
            Text(self.viewModel.envigoratingMessage())
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    var body: some View {
        VStack {
            // Leaderboard Header
            Text("🏆 Leaderboard")
                .font(.title)
                .bold()
                .padding(.top, 20)

            Text("Gold League")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            weekProgress()
                .padding(.bottom, 30)

            HStack {
                let topUsers = viewModel.topUsers
                LeaderboardTopUser(rank: 2, topUsers: topUsers)
                LeaderboardTopUser(rank: 1, topUsers: topUsers)
                LeaderboardTopUser(rank: 3, topUsers: topUsers)
            }

            

            VStack(spacing: 8) {
                ForEach(viewModel.currentUsers.indices, id: \.self) { index in
                    let user = viewModel.currentUsers[index]

                    HStack {
                        Text("\(user.rank).")
                            .bold()

                        Text(user.username)
                            .bold()

                        Spacer()

                        Text("\(user.xp) xp")
                            .foregroundColor(.gray)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemGray6))
                    )
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top )
    }

}

extension User {
    static func placeholder(for rank: Int) -> User {
        return User(rank: rank, username: "No User", xp: 0)
    }
}

// Subview for the Top 3 Users
struct LeaderboardTopUser: View {
    let user: User
    let medal: String
    
    init(rank: Int, topUsers: [User]) {
        self.user = topUsers.count >= rank ? topUsers[rank-1] : User.placeholder(for: rank)
        switch rank {
            case 1:
                self.medal = "🥇"
            case 2:
                self.medal = "🥈"
            case 3:
                self.medal = "🥉"
            default:
                self.medal = ""
        }
    }
    
    var body: some View {
        let rank = user.rank
        
        VStack {
            Text(medal)
                .font(.largeTitle)
            
            Text(user.username)
                .bold()
            
            Text("\(user.xp) xp")
                .foregroundColor(.gray)
        }
        .padding(.top, rank != 1 ? 30: 0)
        .padding(.bottom, rank == 1 ? 50: 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    LeaderboardView()
}
