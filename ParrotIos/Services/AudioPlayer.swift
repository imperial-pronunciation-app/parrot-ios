//
//  AudioPlayer.swift
//  ParrotIos
//
//  Created by jn1122 on 03/03/2025.
//

import AVFoundation

class AudioPlayer: AudioPlayerProtocol {

    func play(url: URL, rate: Float) {
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
