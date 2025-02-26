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
                        .font(.headline)
                        .bold()
                    Text("\(viewModel.league.capitalized) League")
                        .foregroundStyle(.gray)
                    PodiumView(users: viewModel.topUsers)
                        .padding(.vertical, 16)
                }
                .padding(.horizontal)
                ScrollView {
                    VStack {
                        ForEach(viewModel.currentUsers.indices, id: \.self) { index in
                            UserCard(user: viewModel.currentUsers[index], isCurrentUser: false)
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
        }
    }
}

struct PodiumView: View {
    let users: [User]
    var body: some View {
        if users.count < 3 {
            Text("Not enough users for a podium ☹️")
        } else {
            HStack(alignment: .bottom, spacing: 8) {
                PodiumColView(user: users[1], rank: 2)
                PodiumColView(user: users[0], rank: 1)
                PodiumColView(user: users[2], rank: 3)
            }
        }
    }
}

struct PodiumColView: View {
    let user: User
    let rank: Int

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
            Image(systemName: "person.circle.fill")
                .foregroundStyle(Color(UIColor.systemGray4))
                .font(.system(size: 50))
            Text(user.displayName)
                .font(.subheadline)
                .bold()
                .multilineTextAlignment(.center)
            Text("\(user.xp)")
                .foregroundStyle(.gray)
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
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
            Image(systemName: "person.circle.fill")
                .foregroundStyle(Color(UIColor.systemGray4))
                .font(.system(size: 35))
                .frame(width: 40, height: 40)
            Text("\(user.displayName)")
                .fontWeight(isCurrentUser ? .bold : nil)
            Spacer()
            Text("\(user.xp)")
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
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color(UIColor.systemGray4))
                    .offset(y: 0)
            }
        )
    }
}
