//
//  NavigationStack.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

import SwiftUI


// Main Navigation View
struct ContentView: View {
    var body: some View {
        TabView {
            RecordingView()
                .tabItem {
                    Label("Learn", systemImage: "book")
                }
            LeaderboardView(viewModel: LeaderboardViewModel())
                .tabItem {
                    Label("Leaderboard", systemImage: "medal")
                }
        }
    }
}

#Preview {
    ContentView()
}
