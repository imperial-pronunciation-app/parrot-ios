//
//  Phoneme.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

struct Phoneme: Codable, Equatable {
    let id: Int
    let ipa: String
    let respelling: String
    let cdnPath: String
    
    private enum CodingKeys: String, CodingKey {
        case id, ipa, respelling, cdnPath = "cdn_path"
    }
}
