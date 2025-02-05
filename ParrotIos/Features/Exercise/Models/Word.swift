//
//  Word.swift
//  ParrotIos
//
//  Created by James Watling on 22/01/2025.
//

struct Word: Codable {
    let word_id: Int
    let word: String
    let word_phonemes: [Phoneme]
}
