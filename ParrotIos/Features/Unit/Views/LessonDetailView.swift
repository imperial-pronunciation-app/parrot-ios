//
//  LessonDetailView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson

    var body: some View {
        NavigationLink(destination: AttemptView(exerciseId: lesson.firstExerciseID)) {
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
