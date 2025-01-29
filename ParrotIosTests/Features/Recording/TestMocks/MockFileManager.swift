//
//  MockFileManager.swift
//  ParrotIos
//
//  Created by jn1122 on 29/01/2025.
//

import AVFoundation

class MockFileManager: FileManager {
    var mockFileExists = false
    var mockRemoveItemSuccess = true
    
    override func fileExists(atPath path: String) -> Bool {
        return mockFileExists
    }
    
    override func removeItem(at URL: URL) throws {
        if !mockRemoveItemSuccess {
            throw NSError(domain: "MockFileManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to remove item"])
        }
    }
}
