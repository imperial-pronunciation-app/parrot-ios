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
        let audioRecorder = AudioRecorder()
        private(set) var word: Word?
        private(set) var isLoading: Bool = false
        private(set) var errorMessage: String?
        
        private(set) var score: Int?
        
        private let webService = WebService()
        
        func fetchRandomWord() async {
            isLoading = true
            errorMessage = nil
            
            let url = "https://pronunciation-app-backend.doc.ic.ac.uk/api/v1/random_word"
            if let fetchedWord: Word = await webService.downloadData(fromURL: url) {
                self.word = fetchedWord
            } else {
                errorMessage = "Failed to fetch the word."
            }
            
            isLoading = false
        }
        
        func uploadRecording(recordingURL: URL) async {
            isLoading = true
            errorMessage = nil
            
            do {
                let word: Word = self.word!
                let audioData = try Data(contentsOf: recordingURL)
                let requestBody: [String: Any] = [
                    "audio_bytes": audioData.base64EncodedString()
                ]
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
                let url = "https://pronunciation-app-backend.doc.ic.ac.uk/api/v1/\(word.word_id)/recording"
                let recordingResponse: RecordingResponse = await webService.postData(data: jsonData, toURL: url)!
                self.score = recordingResponse.score
            } catch {
                errorMessage = "Error uploading recording."
            }
            
            isLoading = false
        }
    }
}
