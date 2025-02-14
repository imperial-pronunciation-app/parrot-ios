//
//  MockWebService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

@testable import ParrotIos

class MockWebService: WebServiceProtocol, CallTracking {
    var callCounts: [String : Int] = [:]
    var callArguments: [String : [[Any?]]] = [:]
    var returnValues: [String : [Result<Any?, Error>]] = [:]
    
    func downloadData<T>(
        fromURL: String,
        headers: [HeaderElement]
    ) async throws -> T where T: Decodable & Encodable {
        let method = "downloadData"
        recordCall(for: method, with: [fromURL, headers])
        
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func post<T>(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = "post"
        recordCall(for: method, with: [toURL, headers])
        
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func postNoResponse(
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws {
        let method = "postNoResponse"
        recordCall(for: method, with: [toURL, headers])
        
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)

    }
    
    func postData<T>(
        data: Data,
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = "postData"
        recordCall(for: method, with: [data, toURL, headers])
        
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)

    }
    
    func postMultiPartFormData<T>(
        data: [MultiPartFormDataElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = "postMultiPartFormData"
        recordCall(for: method, with: [data, toURL, headers])
        
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
    
    func postURLEncodedFormData<T>(
        parameters: [FormDataURLEncodedElement],
        toURL: String,
        headers: [HeaderElement] = []
    ) async throws -> T where T: Decodable & Encodable {
        let method = "postURLEncodedFormData"
        recordCall(for: method, with: [parameters, toURL, headers])
        
        return try getReturnValue(for: method, callIndex: callCounts[method]! - 1)
    }
}

