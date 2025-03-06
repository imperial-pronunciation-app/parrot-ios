//
//  UnitView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 26/02/2025.
//
import SwiftUI

extension UnitView {
    @Observable
    class ViewModel {
        let unit: Unit

        private(set) var isExpanded: Bool
        var showLessons: Bool {
            isExpanded && !unit.isLocked
        }

        init(unit: Unit, isFirst: Bool, isPrevCompleted: Bool) {
            self.unit = unit
            self.isExpanded = (isPrevCompleted || isFirst) && !unit.isCompleted
        }

        func expandOrCollapse() {
            isExpanded.toggle()
        }
    }
}
