//
//  LeaderboardView.swift
//  ParrotIos
//
//  Created by Tom Smail on 30/01/2025.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    
    private func weekProgress() -> some View {
        VStack {
            Text("\(viewModel.daysProgress.current)/\(viewModel.daysProgress.total) days")
                            .font(.subheadline)
                            .foregroundColor(.gray)

            ProgressView(value: Double(viewModel.daysProgress.current), total: Double(viewModel.daysProgress.total))
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .padding(.horizontal, 40)
            
            Text(viewModel.envigoratingMessage())
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

            if viewModel.users.count >= 3 {
                HStack {
                    LeaderboardTopUser(rank: 2, user: viewModel.users[1], medal: "🥈")
                    LeaderboardTopUser(rank: 1, user: viewModel.users[0], medal: "🥇")
                    LeaderboardTopUser(rank: 3, user: viewModel.users[2], medal: "🥉")
                }
            }

            let remainingUsers = Array(viewModel.users.dropFirst(3))

            VStack(spacing: 10) {
                ForEach(remainingUsers.indices, id: \.self) { index in
                    let user = remainingUsers[index]

                    HStack {
                        Text("\(index + 4).")
                            .bold()

                        Text(user.username)
                            .bold()

                        Spacer()

                        Text("\(user.xp) xp")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemGray5))
                            .shadow(radius: 3)
                    )
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top )
    }

}

// Subview for the Top 3 Users
struct LeaderboardTopUser: View {
    let rank: Int
    let user: User
    let medal: String

    var body: some View {
        VStack {
            Text(medal)
                .font(.largeTitle)
            
            Text(user.username)
                .bold()
            
            Text("\(user.xp) xp")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
