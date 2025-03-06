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

        private(set) var isExpanded: Bool = false
        var showLessons: Bool {
            isExpanded && !unit.isLocked
        }

        init(unit: Unit) {
            self.unit = unit
        }

        func expandOrCollapse() {
            isExpanded.toggle()
        }
    }
}
