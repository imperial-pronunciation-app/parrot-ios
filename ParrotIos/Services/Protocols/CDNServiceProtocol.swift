//
//  CDNServiceProtocol.swift
//  ParrotIos
//
//  Created by jn1122 on 04/03/2025.
//

import Foundation

protocol CDNServiceProtocol {
    
    func download(fromUrl: String) async throws -> URL
}
