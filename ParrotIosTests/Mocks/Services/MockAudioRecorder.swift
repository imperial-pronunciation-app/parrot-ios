//
//  MockAudioRecorder.swift
//  ParrotIosTests
//
//  Created by et422 on 14/02/2025.
//

import AVFoundation

@testable import ParrotIos

struct AudioRecorderMethods {
    static let startRecording = "startRecording"
    static let stopRecording = "stopRecording"
    static let audioRecorderDidFinishRecording = "audioRecorderDidFinishRecording"
    static let getDocumentsDirectory = "getDocumentsDirectory"
    static let getRecordingURL = "getRecordingURL"
}

class MockAudioRecorder: AudioRecorderProtocol, CallTracking {
    
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Result<Any?, Error>]] = [:]
    
    func startRecording() {
        recordCall(for: AudioRecorderMethods.startRecording)
    }
    
    func stopRecording() {
        recordCall(for: AudioRecorderMethods.stopRecording)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordCall(for: AudioRecorderMethods.audioRecorderDidFinishRecording, with: [recorder, flag])
    }
    
    func getDocumentsDirectory() -> URL {
        let method = AudioRecorderMethods.getDocumentsDirectory
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
    func getRecordingURL() -> URL {
        let method = AudioRecorderMethods.getRecordingURL
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
}
