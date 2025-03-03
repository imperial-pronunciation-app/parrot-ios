//
//  AudioPlayer.swift
//  ParrotIos
//
//  Created by jn1122 on 03/03/2025.
//

import AVFoundation

class AudioPlayer: AudioPlayerProtocol {
    private var audioCache = [Int: URL]()
    
    func play(phoneme: Phoneme, rate: Float) {
        if let cachedURL = audioCache[phoneme.id] {
            playFromLocalURL(url: cachedURL, rate: rate)
            return
        }
        
        do {
            let remoteURL = try generateUrl(phoneme: phoneme)
            downloadAndPlay(remoteURL: remoteURL, phonemeId: phoneme.id, rate: rate)
        } catch {
            print("Error generating URL: \(error)")
        }
    }
    
    private func downloadAndPlay(remoteURL: URL, phonemeId: Int, rate: Float) {
        let downloadTask = URLSession.shared.downloadTask(with: remoteURL) { [weak self] (localURL, response, error) in
            guard let self = self, let localURL = localURL, error == nil else {
                print("Download error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let permanentURL = documentsDirectory.appendingPathComponent("\(phonemeId).wav")
            
            do {
                if FileManager.default.fileExists(atPath: permanentURL.path) {
                    try FileManager.default.removeItem(at: permanentURL)
                }
                
                try FileManager.default.moveItem(at: localURL, to: permanentURL)
                
                self.audioCache[phonemeId] = permanentURL
                
                DispatchQueue.main.async {
                    self.playFromLocalURL(url: permanentURL, rate: rate)
                }
            } catch {
                print("Error saving file: \(error)")
            }
        }
        
        downloadTask.resume()
    }
    
    private func playFromLocalURL(url: URL, rate: Float) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.rate = rate
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
    
    private func generateUrl(phoneme: Phoneme) throws -> URL {
        let baseCDNUrl = "https://d2o94ssjf4etxx.cloudfront.net"
        let phonemeFileName = phoneme.id
        let fileExtension = "wav"
        
        let fullUrlString = "\(baseCDNUrl)/\(phonemeFileName).\(fileExtension)"
        
        guard let url = URL(string: fullUrlString) else {
            throw NSError(domain: "AudioPlayerError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(fullUrlString)"])
        }
        
        return url
    }
}
