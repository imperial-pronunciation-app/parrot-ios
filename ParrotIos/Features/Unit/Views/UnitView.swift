//
//  UnitView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

struct UnitView: View {
    let unit: Unit
    let isLast: Bool
    let isNextCompleted: Bool
    let viewModel = ViewModel()

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image(systemName: unit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(unit.isCompleted ? .green : .gray)
                    .font(.system(size: 24))
                if !isLast {
                    // Line to the next unit
                    Rectangle()
                        .frame(width: unit.isCompleted && isNextCompleted ? 2 : 1)
                        .foregroundColor(unit.isCompleted && isNextCompleted ? .green : .gray)
                        .frame(maxHeight: .infinity)
                }
            }
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text(unit.name)
                            .font(.headline)
                            .foregroundColor(unit.isLocked ? .secondary : .black)
                        Text(unit.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if !unit.isLocked {
                        Button(action: {
                            viewModel.expandOrCollapse()
                        }) {
                            Image(systemName: viewModel.isExpanded ? "chevron.down" : "chevron.right")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                if viewModel.isExpanded && !unit.isLocked {
                    ForEach(unit.lessons!) { lesson in
                        ListedLessonView(
                            id: lesson.id,
                            title: lesson.title,
                            isCompleted: lesson.isCompleted,
                            isLocked: lesson.isLocked,
                            stars: lesson.stars
                        )
                            .padding(.top, 8)
                    }
                    if let lesson = unit.recapLesson {
                        ListedLessonView(
                            id: lesson.id,
                            title: lesson.title,
                            isCompleted: lesson.isCompleted,
                            isLocked: lesson.isLocked,
                            stars: lesson.stars,
                            isRecap: true
                        )
                            .padding(.top, 8)
                    } else {
                        ListedLessonView(title: "Recap", isCompleted: false, isLocked: true, isRecap: true)
                            .padding(.top, 8)
                    }
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray)
            )
            .padding(.bottom, 32)
        }
    }
}
