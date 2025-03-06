//
//  UnitView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

struct UnitView: View {
    let isLast: Bool
    let isNextCompleted: Bool
    var viewModel: ViewModel

    init(unit: Unit, isFirst: Bool, isLast: Bool, isPrevCompleted: Bool, isNextCompleted: Bool) {
        self.isLast = isLast
        self.isNextCompleted = isNextCompleted
        self.viewModel = .init(unit: unit, isFirst: isFirst, isPrevCompleted: isPrevCompleted)
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image(systemName: viewModel.unit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewModel.unit.isCompleted ? .green : .gray)
                    .font(.system(size: 24))
                if !isLast {
                    // Line to the next unit
                    Rectangle()
                        .frame(width: viewModel.unit.isCompleted && isNextCompleted ? 2 : 1)
                        .foregroundColor(viewModel.unit.isCompleted && isNextCompleted ? .green : .gray)
                        .frame(maxHeight: .infinity)
                }
            }
            VStack {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text(viewModel.unit.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(viewModel.unit.isLocked ? .secondary : .primary)
                        Text(viewModel.unit.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if !viewModel.unit.isLocked {
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.expandOrCollapse()
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                                .rotationEffect(.degrees(viewModel.isExpanded ? 90 : 0))
                        }
                    }
                }
                VStack(spacing: 4) {
                    if let lessons = viewModel.unit.lessons {
                        ForEach(lessons) { lesson in
                            ListedLessonView(
                                id: lesson.id,
                                title: lesson.title,
                                isCompleted: lesson.isCompleted,
                                isLocked: lesson.isLocked,
                                stars: lesson.stars
                            )
                        }
                    }
                    if let lesson = viewModel.unit.recapLesson {
                        ListedLessonView(
                            id: lesson.id,
                            title: lesson.title,
                            isCompleted: lesson.isCompleted,
                            isLocked: lesson.isLocked,
                            stars: lesson.stars,
                            isRecap: true
                        )
                    } else {
                        ListedLessonView(
                            title: "Recap",
                            isCompleted: false,
                            isLocked: true,
                            isRecap: true
                        )
                    }
                }
                .frame(height: viewModel.showLessons ? nil : 0, alignment: .top)
                .clipped()
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
