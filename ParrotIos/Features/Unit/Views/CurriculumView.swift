//
//  CurriculumView.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

// Curriculum View
struct CurriculumView: View {
    let curriculum: Curriculum

    var body: some View {
        List(curriculum.units) { unit in
            Section(header: Text(unit.name).font(.headline)) {
                UnitView(unit: unit)
            }
        }
    }
}

// Main Content View
struct CurriculumContentView: View {
    let sampleCurriculum = Curriculum(units: [
        Unit(id: 1, name: "Unit 1", description: "Introduction", lessons: [
            Lesson(id: 0, title: "Lesson 1", firstExerciseID: 1, isCompleted: true),
            Lesson(id: 1, title: "Lesson 2", firstExerciseID: 3, isCompleted: false)
            ]),
        Unit(id: 2, name: "Unit 2", description: "Advanced", lessons: [
            Lesson(id: 2, title: "Lesson 3", firstExerciseID: 4, isCompleted: false)
            ])
    ])

    var body: some View {
        CurriculumView(curriculum: sampleCurriculum)
    }
}

#Preview {
    // Must wrap in navigation stack for the linking to work
    CurriculumContentView()
}
