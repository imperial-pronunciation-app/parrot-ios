//
//  ContentView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

// Main Navigation View
struct NavigationView: View {

    var body: some View {
        TabView {
            CurriculumView()
                .tabItem {
                    Label("Learn", systemImage: "text.book.closed")
                }

            WordOfTheDayView()
                .tabItem {
                    Label("Word of the Day", systemImage: "calendar.badge.clock")
                }

            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "medal")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }.onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
