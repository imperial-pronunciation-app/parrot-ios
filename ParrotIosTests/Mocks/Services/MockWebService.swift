//
//  MockWebService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

@testable import ParrotIos

struct WebServiceMethods {
    static let download = "download"
    static let get = "get"
    static let post = "post"
    static let postNoResponse = "postNoRespones"
    static let postData = "postData"
    static let postMultiPartFormData = "postMultiPartFormData"
    static let postURLEncodedFormData = "postURLEncodedFormData"
}

class MockWebService: WebServiceProtocol, CallTracking {
    var callCounts: [String: Int] = [:]
    var callArguments: [String: [[Any?]]] = [:]
    var returnValues: [String: [Result<Any?, Error>]] = [:]

    func download(fromURL: String, headers: [HeaderElement]) async throws -> URL {
        let method = WebServiceMethods.download
        recordCall(for: method, with: [fromURL, headers])

        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func get<T>(
        fromURL: String,
        headers: [HeaderElement]
    ) async throws -> T where T: Decodable & Encodable {
        let method = WebServiceMethods.get
        recordCall(for: method, with: [fromURL, headers])

        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func post<T>(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = WebServiceMethods.post
        recordCall(for: method, with: [toURL, headers])

        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func postNoResponse(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws {
        let method = WebServiceMethods.postNoResponse
        recordCall(for: method, with: [toURL, headers])

        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)

    }

    func postData<T>(
        data: Data,
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = WebServiceMethods.postData
        recordCall(for: method, with: [data, toURL, headers])

        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)

    }

    func postMultiPartFormData<T>(
        data: [MultiPartFormDataElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = WebServiceMethods.postMultiPartFormData
        recordCall(for: method, with: [data, toURL, headers])

        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }

    func postURLEncodedFormData<T>(
        parameters: [FormDataURLEncodedElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = WebServiceMethods.postURLEncodedFormData
        recordCall(for: method, with: [parameters, toURL, headers])

        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
}
