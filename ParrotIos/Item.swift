//
//  Item.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
