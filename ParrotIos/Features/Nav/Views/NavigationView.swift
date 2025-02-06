//
//  ContentView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

// Main Navigation View
struct NavigationView: View {
    let sampleCurriculum = Curriculum(units: [
        Unit(name: "Unit 1", description: "Introduction", lessons: [
            Lesson(id: 0, title: "Lesson 1", currentExerciseID: 1, isCompleted: true),
            Lesson(id: 1, title: "Lesson 2", currentExerciseID: 3, isCompleted: false)
            ]),
        Unit(name: "Unit 2", description: "Advanced", lessons: [
            Lesson(id: 2, title: "Lesson 3", currentExerciseID: 4, isCompleted: false)
            ])
    ])
    var body: some View {
        TabView {
            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "medal")
                }
            NavigationStack {
                CurriculumView(curriculum: sampleCurriculum)
            }
                .tabItem {
                    Label("Curriculum", systemImage: "book")
                }
        }
    }
}
