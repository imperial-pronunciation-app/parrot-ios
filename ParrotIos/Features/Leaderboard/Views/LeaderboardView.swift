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
            
            if viewModel.topUsers.count >= 3 {
                HStack {
                    LeaderboardTopUser(rank: 2, user: viewModel.topUsers[1], medal: "🥈")
                    LeaderboardTopUser(rank: 1, user: viewModel.topUsers[0], medal: "🥇")
                    LeaderboardTopUser(rank: 3, user: viewModel.topUsers[2], medal: "🥉")
                }
                
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
        }.onAppear{
            Task{await viewModel.loadLeaderboard()}
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
        .padding(.top, rank != 1 ? 30: 0)
        .padding(.bottom, rank == 1 ? 50: 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    LeaderboardView()
}
