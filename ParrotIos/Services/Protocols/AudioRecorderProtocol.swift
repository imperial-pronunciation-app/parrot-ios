//
//  AudioRecorderProtocol.swift
//  ParrotIos
//
//  Created by et422 on 14/02/2025.
//

import AVFoundation

protocol AudioRecorderProtocol {
    
    func startRecording()
    
    func stopRecording()
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    
    func getDocumentsDirectory() -> URL
    
    func getRecordingURL() -> URL
}
