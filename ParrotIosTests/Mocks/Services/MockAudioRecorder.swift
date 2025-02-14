//
//  MockAudioRecorder.swift
//  ParrotIosTests
//
//  Created by et422 on 14/02/2025.
//

import AVFoundation

@testable import ParrotIos

class MockAudioRecorder: AudioRecorderProtocol, CallTracking {
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Result<Any?, Error>]] = [:]
    
    func startRecording() {
        recordCall(for: "startRecording")
    }
    
    func stopRecording() {
        recordCall(for: "stopRecording")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordCall(for: "audoRecorderDidFinishRecording", with: [recorder, flag])
    }
    
    func getDocumentsDirectory() -> URL {
        let method = "getDocumentsDirectory"
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
    
    func getRecordingURL() -> URL {
        let method = "getRecordingURL"
        recordCall(for: method)
        
        do {
            return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
        } catch {
            fatalError("MockWebService failed with error: \(error)")
        }
    }
}
