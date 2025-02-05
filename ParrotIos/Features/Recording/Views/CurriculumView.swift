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

struct UnitView: View {
    let unit: Unit
    var body: some View {
        ForEach(unit.lessons) { lesson in
            LessonDetailView(lesson: lesson)
        }
    }
}

struct LessonDetailView: View {
    let lesson: Lesson

    var body: some View {
        NavigationLink(destination: RecordingView()) {
            HStack {
                Text(lesson.title)
                    .font(.subheadline)
                    .padding(.bottom, 2)
                
                Spacer()
                Text(lesson.isCompleted ? "Completed" : "In Progress")
                    .foregroundColor(lesson.isCompleted ? .green : .orange)
                if lesson.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            .padding()
            .background(lesson.isCompleted ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(.plain) 
    }
}

// Main Content View
struct CurriculumContentView: View {
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
        CurriculumView(curriculum: sampleCurriculum)
    }
}

#Preview {
    // Must wrap in navigation stack for the linking to work
    NavigationStack {
        CurriculumContentView()
    }
}
