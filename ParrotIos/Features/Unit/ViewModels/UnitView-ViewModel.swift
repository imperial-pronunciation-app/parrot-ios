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
        private(set) var isExpanded: Bool = false
        
        func expandOrCollapse() {
            isExpanded.toggle()
        }
    }
}

