//
//  ParrotApiService.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 23/01/2025.
//

import Foundation

class ParrotApiService {
    private let baseUrl = "https://pronunciation-app-backend.doc.ic.ac.uk/api/v1/"
    private let webService = WebService()
    
    enum ParrotApiError: Error {
        case customError(String)
    }
    
    func getRandomWord() async -> Result<Word, ParrotApiError> {
        do {
            let word: Word = try await webService.downloadData(fromURL: baseUrl + "random_word")
            return .success(word)
        } catch {
            return .failure(.customError("Failed to fetch the word."))
        }
    }
    
    func postRecording(recordingURL: URL, word: Word) async -> Result<RecordingResponse, ParrotApiError> {
        do {
            let audioData = try Data(contentsOf: recordingURL)
            let requestBody: [String: Any] = [
                "audio_bytes": audioData.base64EncodedString()
            ]
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            let url = baseUrl + "\(word.word_id)/recording"
            let response: RecordingResponse = try await webService.postData(data: jsonData, toURL: url)
            return .success(response)
        } catch {
            return .failure(.customError("Failed to upload recording."))
        }
    }
}
