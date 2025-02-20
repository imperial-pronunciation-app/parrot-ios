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
            NavigationStack {
                CurriculumView()
            }
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
        }
    }
}
