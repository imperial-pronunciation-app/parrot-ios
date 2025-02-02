//
//  AudioRecorder.swift
//  ParrotIos
//
//  Created by Kyle Lee (https://www.kiloloco.com/articles/023-aws-amplify-storage-with-audio-files/).
//

import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    var osAudioRecorder: AVAudioRecorder?
    private(set) var isRecording = false
    
    // TODO: Review this code
    // Custom initializer to inject the AVAudioRecorder dependency
    init(avAudioRecorder: AVAudioRecorder? = nil) {
        super.init()
        if let recorder = avAudioRecorder {
            self.osAudioRecorder = recorder
        } else {
            let url = getDocumentsDirectory().appendingPathComponent("default.wav")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                self.osAudioRecorder = try AVAudioRecorder(url: url, settings: settings)
            } catch {
                print("Failed to initialize AVAudioRecorder: \(error.localizedDescription)")
            }
        }
    }
    
    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            try session.setActive(true)
            let url = getDocumentsDirectory().appendingPathComponent("recording.wav")
            
            // TODO: Ensure any previous uploads have completed before removing file
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.removeItem(at: url)
                    print("Previous recording removed.")
                } catch {
                    print("Failed to remove existing file: \(error.localizedDescription)")
                }
            }
            self.osAudioRecorder!.delegate = self
            osAudioRecorder!.record()
            isRecording = true
        } catch let error {
            print("Error recording audio: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        osAudioRecorder!.stop()
        isRecording = false
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording failed")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getAudioFileURL() -> URL {
        return osAudioRecorder!.url
    }
}
