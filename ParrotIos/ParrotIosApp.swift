//
//  ParrotIosApp.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI
import SwiftData

// Main Navigation View
struct ContentView: View {
    let sampleCurriculum = Curriculum(units: [
        Unit(id: 1, name: "Unit 1", description: "Introduction", lessons: [
            Lesson(id: 0, title: "Lesson 1", firstExerciseID: 1, isCompleted: true),
            Lesson(id: 1, title: "Lesson 2", firstExerciseID:  3, isCompleted: false)
            ]),
        Unit(id: 2, name: "Unit 2", description: "Advanced", lessons: [
            Lesson(id: 2, title: "Lesson 3", firstExerciseID:  4, isCompleted: false)
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

@main
struct ParrotIosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
