//
//  WordTests.swift
//  ParrotIosTests
//
//  Created by jn1122 on 29/01/2025.
//

import Testing
import Foundation
@testable import ParrotIos

@Suite("Word Model Tests")
struct WordTests {

    var phoneme1: Phoneme
    var phoneme2: Phoneme
    var phoneme3: Phoneme
    
    var word: Word
    
    init() {
        phoneme1 = Phoneme(id: 1, ipa: "s", respelling: "s")
        phoneme2 = Phoneme(id: 2, ipa: "ɪ", respelling: "i (irr)")
        phoneme3 = Phoneme(id: 3, ipa: "t", respelling: "t")

        word = Word(word_id: 1, word: "sit", word_phonemes: [phoneme1, phoneme2, phoneme3])
    }
    
    @Test("Word when initialized creates a valid word")
    func wordInitialization() async throws {
        #expect(word.word_id == 1)
        #expect(word.word == "sit")
        #expect(word.word_phonemes.count == 3)
        #expect(word.word_phonemes == [phoneme1, phoneme2, phoneme3])
    }
    
    @Test("Word when encoded and decoded from JSON matches original data")
    func testWordEncodingDecoding() async throws {
        let encodedWord = try JSONEncoder().encode(word)
        let decodedWord = try JSONDecoder().decode(Word.self, from: encodedWord)

        #expect(decodedWord == word)
    }

    @Test("Same words when compared are equal")
    func testWordEquality() async throws {
        let sameWord = Word(word_id: 1, word: "sit", word_phonemes: [phoneme1, phoneme2, phoneme3])

        #expect(word == sameWord)
    }
    
    @Test("Different words when compared are not equal")
    func testWordInequality() async throws {
        let differentWord1 = Word(word_id: 2, word: "sit", word_phonemes: [phoneme1, phoneme2, phoneme3])
        let differentWord2 = Word(word_id: 1, word: "sat", word_phonemes: [phoneme1, phoneme2, phoneme3])
        let differentWord3 = Word(word_id: 1, word: "sit", word_phonemes: [phoneme1, phoneme2])
        
        #expect(word != differentWord1)
        #expect(word != differentWord2)
        #expect(word != differentWord3)
    }
}
