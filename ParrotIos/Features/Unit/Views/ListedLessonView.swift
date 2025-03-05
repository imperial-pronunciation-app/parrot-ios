//
//  ListedLessonView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

struct ListedLessonView: View {
    let id: Int?
    let title: String
    let isCompleted: Bool
    let isLocked: Bool
    let isRecap: Bool
    let stars: Int?

    init(id: Int? = nil, title: String, isCompleted: Bool, isLocked: Bool, stars: Int? = nil, isRecap: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.isRecap = isRecap
        self.stars = stars
    }

    var body: some View {
        HStack {
            if isLocked {
                Image(systemName: "lock")
                    .foregroundStyle(.secondary)
            } else if isCompleted {
                StarsView(filledStars: stars!)
            }

            Text(title)
                .font(.body)
                .foregroundStyle(isLocked ? .secondary : .primary)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            if isLocked {
                Color.clear.frame(width: 32, height: 32)
            } else {
                NavigationLink(destination: LessonView(lessonId: id!)) {
                    Image(systemName: isCompleted ? "arrow.clockwise.circle.fill" : "play.circle.fill")
                        .foregroundStyle(isCompleted ? .gray : .accentColor)
                        .font(.system(size: 32))
                }
                .simultaneousGesture(
                    TapGesture().onEnded {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                )

            }
        }
    }
}
