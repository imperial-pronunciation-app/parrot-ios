//
//  Word.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

struct Word: Codable, Equatable {
    let id: Int
    let text: String
    let phonemes: [Phoneme]
}
