//
//  LeaderboardView.swift
//  ParrotIos
//
//  Created by James Watling on 25/02/2025.
//

import SwiftUI

struct LeaderboardView: View {
    private let viewModel = ViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                VStack {
                    Text("Leaderboard")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 4)
                    Text("\(viewModel.league.capitalized) League")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    PodiumView(users: viewModel.topUsers, currentUserId: viewModel.currentUserId())
                        .padding(.vertical, 16)
                }
                .padding(.horizontal)
                ScrollView {
                    VStack {
                        ForEach(viewModel.currentUsers) { user in
                            UserCard(user: user, isCurrentUser: user.id == viewModel.currentUserId())
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                        .frame(height: 80)
                }
            }

            VStack {
                Spacer()
                ResetTimerView(currentDays: viewModel.daysProgress.current, totalDays: viewModel.daysProgress.total)
            }
        }.task {
            await viewModel.loadLeaderboard()
        }
    }
}

struct PodiumView: View {
    let users: [User]
    let currentUserId: Int
    var body: some View {
        if users.count < 3 {
            Text("Not enough users for a podium ☹️")
        } else {
            HStack(alignment: .bottom, spacing: 8) {
                PodiumColView(user: users[1], rank: 2, isCurrentUser: users[1].id == currentUserId)
                PodiumColView(user: users[0], rank: 1, isCurrentUser: users[0].id == currentUserId)
                PodiumColView(user: users[2], rank: 3, isCurrentUser: users[2].id == currentUserId)
            }
        }
    }
}

struct PodiumColView: View {
    let user: User
    let rank: Int
    let isCurrentUser: Bool

    func colourFor(rank: Int) -> Color {
        return switch rank {
        case 1:
            Color(.yellow)
        case 2:
            Color(.gray)
        case 3:
            Color(red: 0.8, green: 0.5, blue: 0.2)
        default:
            Color(.blue)
        }
    }

    func heightFor(rank: Int) -> CGFloat {
        return switch rank {
        case 1:
            100
        case 2:
            75
        case 3:
            65
        default:
            0
        }
    }

    var body: some View {
        VStack {
            getAvatar(for: user.avatar, size: 50)
            Text(user.displayName)
                .font(.subheadline)
                .bold()
                .multilineTextAlignment(.center)
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.yellow)
                Text("\(user.xp)")
                    .foregroundStyle(.gray)
            }
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isCurrentUser ? Color.accentColor.opacity(0.15) : Color(UIColor.systemGray6))
                    .stroke(isCurrentUser ? Color.accentColor : .clear, lineWidth: 1)
                    .frame(width: 110, height: heightFor(rank: user.rank))
                ZStack {
                    Circle()
                        .fill(colourFor(rank: user.rank))
                        .frame(width: 30, height: 30)
                    Text("\(user.rank)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .offset(y: 12)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct UserCard: View {
    let user: User
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            Text("\(user.rank)")
                .foregroundStyle(.gray)
                .frame(width: 20)
                .fontWeight(isCurrentUser ? .bold : nil)
            getAvatar(for: user.avatar, size: 40)
            Text("\(user.displayName)")
                .fontWeight(isCurrentUser ? .bold : nil)
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.yellow)
                Text("\(user.xp)")
                    .fontWeight(isCurrentUser ? .bold : nil)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(isCurrentUser ? Color.accentColor.opacity(0.15) : .clear)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 1) // inset value should be same as lineWidth in .stroke
                .stroke(isCurrentUser ? .accentColor : Color(UIColor.systemGray4), lineWidth: 1)
        )
    }
}

func iconForDays(current: Int, total: Int) -> Image {
    let timeThrough = CGFloat(current) / CGFloat(total)

    if timeThrough < 0.25 {
        return Image(systemName: "hourglass.bottomhalf.filled")
    } else if timeThrough < 0.75 {
        return Image(systemName: "hourglass")
    } else {
        return Image(systemName: "hourglass.tophalf.filled")
    }
}

struct ResetTimerView: View {
    let currentDays: Int
    let totalDays: Int

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                iconForDays(current: currentDays, total: totalDays)
                    .foregroundStyle(Color.accentColor)
                Text("Leaderboard resets in \(totalDays - currentDays) days!")
            }

            ProgressView(value: Double(currentDays), total: Double(totalDays))
                .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(Color(UIColor.systemBackground))
        .overlay(
            VStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color(UIColor.systemGray4))
                    .offset(y: 0)
                Spacer()
            }
        )
    }
}
