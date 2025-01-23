//
//  WebService.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

import Foundation

class WebService {
    func downloadData<T: Codable>(fromURL: String) async throws -> T {
        guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
                
        return decodedResponse
    }
    
    func postFormData<T: Codable>(data: [FormDataElement], toURL: String) async throws -> T {
        // Create the request
        guard let url = URL(string: toURL) else { throw NetworkError.badUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        for element in data {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(element.name)\"".data(using: .utf8)!)
            if let filename = element.filename {
                body.append("; filename=\"\(filename)\"".data(using: .utf8)!)
            }
            body.append("\r\n".data(using: .utf8)!)
            if let contentType = element.contentType {
                body.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
            }
            body.append(element.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let(responseData, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: responseData) else { throw NetworkError.failedToDecodeResponse }
        
        return decodedResponse
    }
}

struct FormDataElement {
    let name: String
    let filename: String?
    let contentType: String?
    let data: Data
}

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}
