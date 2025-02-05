//
//  UnitView.swift
//  ParrotIos
//
//  Created by et422 on 05/02/2025.
//

import SwiftUI

struct UnitView: View {
    let unit: Unit
    var body: some View {
        ForEach(unit.lessons) { lesson in
            LessonDetailView(lesson: lesson)
        }
    }
}
