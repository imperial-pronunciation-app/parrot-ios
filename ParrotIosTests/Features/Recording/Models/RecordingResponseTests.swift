//
//  RecordingResponseTests.swift
//  ParrotIosTests
//
//  Created by jn1122 on 29/01/2025.
//

import Testing
import Foundation
@testable import ParrotIos

@Suite("Recording Response Model Tests")
struct RecordingResponseTests {

    var phoneme1: Phoneme
    var phoneme2: Phoneme
    var phoneme3: Phoneme
    
    var recordingResponse: RecordingResponse
    
    init() {
        phoneme1 = Phoneme(id: 1, ipa: "s", respelling: "s")
        phoneme2 = Phoneme(id: 2, ipa: "ɪ", respelling: "i (irr)")
        phoneme3 = Phoneme(id: 3, ipa: "t", respelling: "t")

        recordingResponse = RecordingResponse(
            recording_id: 1,
            score: 95,
            recording_phonemes: [phoneme1, phoneme2, phoneme3]
        )
    }
    
    @Test("Recording Response when initialized creates a valid response")
    func recordingResponseInitialization() async throws {
        #expect(recordingResponse.recording_id == 1)
        #expect(recordingResponse.score == 95)
        #expect(recordingResponse.recording_phonemes == [phoneme1, phoneme2, phoneme3])
    }
    
    @Test("Recording Response when encoded and decoded from JSON matches original data")
    func testRecordingResponseEncodingDecoding() async throws {
        let encodedResponse = try JSONEncoder().encode(recordingResponse)
        let decodedResponse = try JSONDecoder().decode(RecordingResponse.self, from: encodedResponse)

        #expect(recordingResponse == decodedResponse)
    }

    @Test("Same Recording Response when compared are equal")
    func testRecordingResponseEquality() async throws {
        let sameResponse = RecordingResponse(
            recording_id: 1,
            score: 95,
            recording_phonemes: [phoneme1, phoneme2, phoneme3]
        )

        #expect(recordingResponse == sameResponse)
    }
    
    @Test("Different Recording Response when compared are not equal")
    func testRecordingResponseInequality() async throws {
        let differentResponse1 = RecordingResponse(
            recording_id: 2, // Different recording_id
            score: 95,
            recording_phonemes: [phoneme1, phoneme2, phoneme3]
        )
        let differentResponse2 = RecordingResponse(
            recording_id: 1,
            score: 90, // Different score
            recording_phonemes: [phoneme1, phoneme2, phoneme3]
        )
        let differentResponse3 = RecordingResponse(
            recording_id: 1,
            score: 95,
            recording_phonemes: [phoneme1, phoneme2] // Different phonemes
        )
        
        #expect(recordingResponse != differentResponse1)
        #expect(recordingResponse != differentResponse2)
        #expect(recordingResponse != differentResponse3)
    }
}
