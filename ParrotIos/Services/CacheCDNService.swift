//
//  CDNService.swift
//  ParrotIos
//
//  Created by jn1122 on 04/03/2025.
//

import Foundation

class CacheCDNService: CDNServiceProtocol {
    
    private let webService: WebServiceProtocol
    
    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }
    
    
    func download(fromUrl: String) async throws -> URL {
    
        guard let cdnURL = Bundle.main.object(forInfoDictionaryKey: "CDN_URL") as? String else {
            fatalError("CDN_URL not found in Info.plist")
        }
        
        let fullCDNURL = "https://\(cdnURL)/\(phoneme.cdnPath)"


        let (localURL, _) = try await URLSession.shared.download(from: generateCDNUrl(phoneme: phoneme))
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let permanentURL = documentsDirectory.appendingPathComponent("\(phoneme.cdnPath).wav")
        
        do {
            if FileManager.default.fileExists(atPath: permanentURL.path) {
                try FileManager.default.removeItem(at: permanentURL)
            }
            
            try FileManager.default.moveItem(at: localURL, to: permanentURL)
            return permanentURL
        } catch {
            throw error
        }
    }


    private func generateCDNUrl(phoneme: Phoneme) throws -> URL {

        
        guard let url = URL(string: fullCDNURL) else {
            throw NSError(domain: "CDNServiceError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(fullCDNURL)"])
        }
        
        return url
    }
    
}
