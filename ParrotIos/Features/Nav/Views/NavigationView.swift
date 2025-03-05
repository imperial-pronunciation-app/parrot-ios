//
//  ContentView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

// Main Navigation View
struct NavigationView: View {

    @State private var selection: Int = 1

    var body: some View {
        TabView(selection: $selection) {
            CurriculumView()
                .tabItem {
                    Label("Learn", systemImage: "text.book.closed")
                }
                .tag(0)

            WordOfTheDayView()
                .tabItem {
                    Label("Word of the Day", systemImage: "calendar.badge.clock")
                }
                .tag(1)

            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "medal")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }.onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
