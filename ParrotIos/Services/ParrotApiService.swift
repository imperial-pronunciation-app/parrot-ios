//
//  ParrotApiService.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 23/01/2025.
//

import Foundation

class ParrotApiService {
    private let baseURL = "https://" + (Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String)
    private let webService = WebService()
    
    enum ParrotApiError: Error {
        case customError(String)
    }
    
    func getRandomWord() async -> Result<Word, ParrotApiError> {
        do {
            let word: Word = try await webService.downloadData(fromURL: "\(baseURL)/random_word")
            return .success(word)
        } catch {
            return .failure(.customError("Failed to fetch the word."))
        }
    }
    
    func postRecording(recordingURL: URL, word: Word) async -> Result<RecordingResponse, ParrotApiError> {
        do {
            let audioFile = try Data(contentsOf: recordingURL)
            
            let formData: [MultiPartFormDataElement] = [
                MultiPartFormDataElement(name: "audio_file", filename: "recording.wav", contentType: "audio/wav", data: audioFile)
            ]
            
            let url = "\(baseURL)/words/\(word.word_id)/recording"
            let response: RecordingResponse = try await webService.postMultiPartFormData(data: formData, toURL: url)
            return .success(response)
        } catch {
            return .failure(.customError("Failed to upload recording."))
        }
    }
}
