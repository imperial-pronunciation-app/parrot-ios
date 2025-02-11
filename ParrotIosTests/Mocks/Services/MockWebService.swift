//
//  MockWebService.swift
//  ParrotIosTests
//
//  Created by et422 on 11/02/2025.
//

import Foundation

class MockWebService: WebService {
    
    override func downloadData<T>(fromURL: String, headers: [HeaderElement] = []) async throws -> T where T : Decodable, T : Encodable {
        fatalError("Mock not implemented")
    }
    
    override func post<T>(toURL: String, headers: [HeaderElement] = []) async throws -> T where T : Decodable, T : Encodable {
        fatalError("Mock not implemented")
    }
    
    override func postNoResponse(toURL: String, headers: [HeaderElement] = []) async throws {
        fatalError("Mock not implemented")
    }
    
    override func postData<T>(data: Data, toURL: String, headers: [HeaderElement] = []) async throws -> T where T : Decodable, T : Encodable {
        fatalError("Mock not implemented")
    }
    
    override func postMultiPartFormData<T>(data: [MultiPartFormDataElement], toURL: String, headers: [HeaderElement] = []) async throws -> T where T : Decodable, T : Encodable {
        fatalError("Mock not implemented")
    }
    
    override func postURLEncodedFormData<T>(parameters: [FormDataURLEncodedElement], toURL: String, headers: [HeaderElement] = []) async throws -> T where T : Decodable, T : Encodable {
        fatalError("Mock not implemented")
    }
    
}
