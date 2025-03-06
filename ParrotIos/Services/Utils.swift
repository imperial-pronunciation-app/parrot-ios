//
//  Utils.swift
//  ParrotIos
//
//  Created by Henry Yu on 22/2/2025.
//

import Foundation
import SwiftUI

func getBaseUrl() -> String {
    guard let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
        fatalError("API_BASE_URL not found in Info.plist")
    }
    return "http://" + urlString
}

func generateAuthHeader(accessToken: String) -> HeaderElement {
    return HeaderElement(key: "Authorization", value: "Bearer " + accessToken)
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getAvatar(for name: String, size: CGFloat) -> some View {
    return Image("\(name.lowercased())-bird")
        .resizable()
        .scaledToFit()
        .frame(width: size, height: size)
        .clipShape(Circle())
}
