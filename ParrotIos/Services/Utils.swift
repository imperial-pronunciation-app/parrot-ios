//
//  Utils.swift
//  ParrotIos
//
//  Created by Henry Yu on 22/2/2025.
//

import Foundation

func getBaseUrl() -> String {
    guard let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
        fatalError("API_BASE_URL not found in Info.plist")
    }
    return "https://" + urlString
}

func generateAuthHeader(accessToken: String) -> HeaderElement {
    return HeaderElement(key: "Authorization", value: "Bearer " + accessToken)
}
