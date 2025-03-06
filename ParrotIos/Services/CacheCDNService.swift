//
//  CDNService.swift
//  ParrotIos
//
//  Created by jn1122 on 04/03/2025.
//

import Foundation

class CacheCDNService: CDNServiceProtocol {

    static var instance = CacheCDNService()
    private let webService: WebServiceProtocol
    private var cache = [String: URL]()

    private init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }

    func download(fromPath: String) async throws -> URL {

        if let url = cache[fromPath] {
            return url
        }

        guard let cdnURL = Bundle.main.object(forInfoDictionaryKey: "CDN_URL") as? String else {
            fatalError("CDN_URL not found in Info.plist")
        }

        let fullCDNURL = "https://" + cdnURL + "/\(fromPath)"

        let localURL = try await self.webService.download(fromURL: fullCDNURL, headers: [])

        let documentsDirectory = getDocumentsDirectory()
        let fileName = (fromPath as NSString).lastPathComponent
        let permanentURL = documentsDirectory.appendingPathComponent("\(fileName)")

        do {
            if FileManager.default.fileExists(atPath: permanentURL.path) {
                try FileManager.default.removeItem(at: permanentURL)
            }

            try FileManager.default.moveItem(at: localURL, to: permanentURL)
            cache[fromPath] = permanentURL
            return permanentURL
        } catch {
            throw error
        }
    }
}
