//
//  MockAudioRecorder.swift
//  ParrotIos
//
//  Created by jn1122 on 29/01/2025.
//

import AVFoundation

class MockAudioRecorder: AudioRecorder {
    var startRecordingCalled = false
    var stopRecordingCalled = false
    
    override func startRecording() {
        startRecordingCalled = true
    }
    
    override func stopRecording() {
        stopRecordingCalled = true
    }
    
    override func getAudioFileURL() -> URL {
        return URL(string: "file:///path/to/file")!
    }
}
