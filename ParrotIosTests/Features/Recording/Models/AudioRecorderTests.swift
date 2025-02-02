//
//  AudioRecorderTests.swift
//  ParrotIosTests
//
//  Created by jn1122 on 29/01/2025.
//

import Testing
import AVFoundation
@testable import ParrotIos

@Suite("Audio Recorder Model Tests")
struct AudioRecorderTests {

    var audioRecorder: AudioRecorder
    var mockAVAudioRecorder: MockAVAudioRecorder
    var mockFileManager: MockFileManager
    
    init() {
        mockFileManager = MockFileManager()
        let url = URL(fileURLWithPath: "recording.wav")
        mockAVAudioRecorder = try! MockAVAudioRecorder(url: url, settings: [:])
        
        audioRecorder = AudioRecorder(avAudioRecorder: mockAVAudioRecorder)
    }
    
    @Test("Start recording successfully by correctly calling the avAudioRecorder")
    func startRecording() async throws {
        mockFileManager.mockFileExists = false
        audioRecorder.startRecording()
        
        //TODO: consider using a mocking library?
        #expect(audioRecorder.isRecording == true)
        #expect(mockAVAudioRecorder.mockIsRecording == true)
    }
    
    @Test("Get audio file URL matches the AVAudioRecorder audio file URL")
    func getAudioFileURL() async throws {
        let expectedURL = URL(fileURLWithPath: "recording.wav")
        mockAVAudioRecorder.mockUrl = expectedURL
        
        let fileURL = audioRecorder.getAudioFileURL()
        
        #expect(fileURL == expectedURL)
    }
}
