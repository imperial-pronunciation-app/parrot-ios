//
//  MockAVAudioRecorder.swift
//  ParrotIos
//
//  Created by jn1122 on 29/01/2025.
//
import AVFoundation

class MockAVAudioRecorder: AVAudioRecorder, @unchecked Sendable {
    var mockIsRecording = false
    var mockUrl: URL
    var mockSettings: [String: Any]
    
    override init(url: URL, settings: [String: Any]) throws {
        self.mockUrl = url
        self.mockSettings = settings
        try super.init(url: url, settings: settings)
    }
    
    override func record() -> Bool {
        mockIsRecording = true
        return true
    }
    
    override func stop() {
        mockIsRecording = false
    }
    
    override var isRecording: Bool {
        return mockIsRecording
    }
}
