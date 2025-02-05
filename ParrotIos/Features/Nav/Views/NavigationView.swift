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
            Lesson(title: "Lesson 1", currentExerciseID: 1, isCompleted: true),
            Lesson(title: "Lesson 2", currentExerciseID: 3, isCompleted: false)
            ]),
        Unit(name: "Unit 2", description: "Advanced", lessons: [
            Lesson(title: "Lesson 3", currentExerciseID: 4, isCompleted: false)
            ])
    ])
    var body: some View {
        TabView {
//            RecordingView()
//                .tabItem {
//                    Label("Learn", systemImage: "book")
//                }
            LeaderboardView(viewModel: LeaderboardViewModel())
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
