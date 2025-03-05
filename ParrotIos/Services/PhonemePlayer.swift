//
//  PhonemePlayer.swift
//  ParrotIos
//
//  Created by jn1122 on 04/03/2025.
//

import AVFoundation

class PhonemePlayer {

    private let cdnService: CDNServiceProtocol
    private let audioPlayer: AudioPlayerProtocol
    
    init(cdnService: CDNServiceProtocol = CacheCDNService(), audioPlayer: AudioPlayerProtocol = AudioPlayer()) {
        self.cdnService = cdnService
        self.audioPlayer = audioPlayer
    }
    
    func play(phoneme: Phoneme, rate: Float) async {
        do {
            let url = try await self.cdnService.download(fromPath: phoneme.cdnPath!)
            self.audioPlayer.play(url: url, rate: rate)
        } catch {
            print(error.localizedDescription)
        }
    }
}
