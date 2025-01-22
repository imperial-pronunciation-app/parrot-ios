//
//  RecordingView-ViewModel.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import Foundation
import MapKit
import SoundControlKit

extension RecordingView {
    @Observable
    class ViewModel {
        
        private(set) var word: String
        private(set) var phonemes: [[String: String]]
        let audioRecorder = AudioRecorder()
                
        init() {
            word = "software"
            phonemes = [
                ["respelling": "s"],
                ["respelling": "aw"],
                ["respelling": "f"],
                ["respelling": "t"],
                ["respelling": "w"],
                ["respelling": "eh"],
                ["respelling": "r"],
            ]
        }
    }
}
