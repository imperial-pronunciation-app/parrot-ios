//
//  WebService.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

import Foundation

class WebService: WebServiceProtocol {
    
    private func formRequest(url: String, method: String, headers: [HeaderElement]) throws -> URLRequest {
        guard let url = URL(string: url) else { throw NetworkError.badURL }
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    private func sendAndCheckStatus(request: URLRequest) async throws -> Data? {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus(code: response.statusCode, data: data) }
        return data
    }
    
    private func decodeResponse<T: Decodable>(data: Data?) throws -> T {
        guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data!) else {
            throw NetworkError.failedToDecodeResponse
        }
        return decodedResponse
    }
    
    func get<T: Codable>(fromURL: String, headers: [HeaderElement] = []) async throws -> T {
        let request = try formRequest(url: fromURL, method: "GET", headers: headers)
        let data = try await sendAndCheckStatus(request: request)
        return try decodeResponse(data: data)
        
    }
    
    // MARK: - POST with no data
    func post<T: Codable>(toURL: String, headers: [HeaderElement] = []) async throws -> T {
        let request = try formRequest(url: toURL, method: "POST", headers: headers)
        let data = try await sendAndCheckStatus(request: request)
        return try decodeResponse(data: data)
    }
    
    // MARK: - POST with no data and no response
    func postNoResponse(toURL: String, headers: [HeaderElement] = []) async throws {
        let request = try formRequest(url: toURL, method: "POST", headers: headers)
        let _ = try await sendAndCheckStatus(request: request)
    }
    
    // MARK: - POST for application/json type
    func postData<T: Codable>(data: Data, toURL: String, headers: [HeaderElement] = []) async throws -> T {
        var request = try formRequest(url: toURL, method: "POST", headers: headers)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let data = try await sendAndCheckStatus(request: request)
        return try decodeResponse(data: data)
    }
    
    // MARK: - POST for multipart/form-data
    func postMultiPartFormData<T: Codable>(
        data: [MultiPartFormDataElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T {
        // Create the request
        var request = try formRequest(url: toURL, method: "POST", headers: headers)
        
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
        
        let data = try await sendAndCheckStatus(request: request)
        return try decodeResponse(data: data)
    }
    
    // MARK: - POST for application/x-www-form-urlencoded
    func postURLEncodedFormData<T: Codable>(parameters: [FormDataURLEncodedElement], toURL: String, headers: [HeaderElement] = []) async throws -> T {
        var request = try formRequest(url: toURL, method: "POST", headers: headers)
        var formComponents = URLComponents()
        formComponents.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let formComponentsEncoded = formComponents.percentEncodedQuery else {
            throw NetworkError.failedToEncodeData
        }

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formComponentsEncoded.data(using: .utf8)
        
        let data = try await sendAndCheckStatus(request: request)
        return try decodeResponse(data: data)
    }
}

struct ErrorResponse: Codable {
    let error: String
    let message: String
}

struct MultiPartFormDataElement {
    let name: String
    let filename: String?
    let contentType: String?
    let data: Data
}

struct FormDataURLEncodedElement {
    let key: String
    let value: String
}

struct HeaderElement {
    let key: String
    let value: String
}

enum NetworkError: Error {
    case badURL
    case invalidRequest
    case badResponse
    case badStatus(code: Int, data: Data? = nil)
    case failedToDecodeResponse
    case failedToEncodeData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("The URL provided was invalid.", comment: "Invalid URL")
        case .invalidRequest:
            return NSLocalizedString("The request could not be created.", comment: "Invalid Request")
        case .badResponse:
            return NSLocalizedString("The server response was invalid.", comment: "Bad Response")
        case .badStatus(let code, _):
            return String(format: NSLocalizedString("Received an unexpected HTTP status code: %d.", comment: "Unexpected Status Code"), code)
        case .failedToDecodeResponse:
            return NSLocalizedString("Failed to decode the server response.", comment: "Decoding Error")
        case .failedToEncodeData:
            return NSLocalizedString("Failed to encode the request data.", comment: "Encoding Error")
        }
    }
}
