//
//  AudioPlayer.swift
//  ParrotIos
//
//  Created by jn1122 on 03/03/2025.
//

import AVFoundation

class AudioPlayer: AudioPlayerProtocol {
    private var audioCache = [Int: URL]()
    private let cdnService: CDNServiceProtocol
    
    init(cdnService: CDNServiceProtocol = CDNService()) {
        self.cdnService = cdnService
    }
    
    func play(phoneme: Phoneme, rate: Float) {
        if audioCache[phoneme.id] == nil {
            Task {
                do {
                    let permanentURL = try await cdnService.download(phoneme: phoneme)
                    
                    self.audioCache[phoneme.id] = permanentURL
        
                } catch let error {
                    print("Error downloading or playing audio: \(error.localizedDescription)")
                }
            }
        }
        let cachedURL = audioCache[phoneme.id]!
        playFromLocalURL(url: cachedURL, rate: rate)
    }

    private func playFromLocalURL(url: URL, rate: Float) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.rate = rate
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
