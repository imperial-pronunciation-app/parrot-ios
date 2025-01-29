//
//  PhonemeTests.swift
//  ParrotIosTests
//
//  Created by jn1122 on 29/01/2025.
//

import Testing
import Foundation
@testable import ParrotIos

@Suite("Phoneme Model Tests")
struct PhonemeTests {

    var phoneme: Phoneme
    
    init() {
        phoneme = Phoneme(id: 1, ipa: "p", respelling: "p")
    }
    
    @Test("Phoneme when initialized creates a valid phoneme")
    func phonemeInitialization() async throws {
        #expect(phoneme.id == 1)
        #expect(phoneme.ipa == "p")
        #expect(phoneme.respelling == "p")
    }
    
    @Test("Phoneme when encoded and decoded from JSON matches original data")
    func testPhonemeEncodingDecoding() async throws {
        let encodedPhoneme = try JSONEncoder().encode(phoneme)
        let decodedPhoneme = try JSONDecoder().decode(Phoneme.self, from: encodedPhoneme)

        #expect(decodedPhoneme == phoneme)
    }

    @Test("Same phonemes when compared are equal")
    func testPhonemeEquality() async throws {
        let samePhoneme = Phoneme(id: 1, ipa: "p", respelling: "p")
        #expect(phoneme == samePhoneme)
    }
    
    @Test("Different phonemes when compared are not equal")
    func testPhonemeInequality() async throws {
        let differentPhoneme1 = Phoneme(id: 2, ipa: "p", respelling: "p")
        let differentPhoneme2 = Phoneme(id: 1, ipa: "p", respelling: "q")
        let differentPhoneme3 = Phoneme(id: 1, ipa: "q", respelling: "p")
        
        #expect(phoneme != differentPhoneme1)
        #expect(phoneme != differentPhoneme2)
        #expect(phoneme != differentPhoneme3)
    }
}
