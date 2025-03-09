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
    let callback: (() async -> Void)?

    init(
        id: Int? = nil,
        title: String,
        isCompleted: Bool,
        isLocked: Bool,
        stars: Int? = nil,
        isRecap: Bool = false,
        callback: (() async -> Void)? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.isRecap = isRecap
        self.stars = stars
        self.callback = callback
    }

    var body: some View {
        if isLocked {
            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(.secondary)

                Text(title)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer()

                Color.clear.frame(width: 32, height: 32)
            }

        } else {
            NavigationLink(destination: LessonView(lessonId: id!).onDisappear {
                Task {
                    if let callback = callback {
                        await callback()
                    }
                }
            }) {
                HStack {
                    // Show stars if completed, otherwise maybe nothing
                    if isCompleted {
                        StarsView(filledStars: stars ?? 0)
                    }

                    Text(title)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    Image(systemName: isCompleted ? "arrow.clockwise.circle.fill" : "play.circle.fill")
                        .foregroundStyle(isCompleted ? .gray : .accentColor)
                        .font(.system(size: 32))
                }
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                TapGesture().onEnded {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }
            )
        }
    }
}
