//
//  AudioRecorder.swift
//  ParrotIos
//
//  Created by Kyle Lee (https://www.kiloloco.com/articles/023-aws-amplify-storage-with-audio-files/).
//

import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate, AudioRecorderProtocol {

    var audioRecorder: AVAudioRecorder!
    private(set) var isRecording = false

    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            try session.setActive(true)
            let url = getDocumentsDirectory().appendingPathComponent("recording.wav")

            // TODO: move deletion to audioRecorderDidFinishRecording after upload is completed
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    print("Failed to remove existing file: \(error.localizedDescription)")
                }
            }

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            isRecording = true
        } catch let error {
            print("Error recording audio: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
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

    func getRecordingURL() -> URL {
        return audioRecorder.url
    }
}
