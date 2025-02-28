//
//  AttemptDecoding.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 28/02/2025.
//

enum AttemptDecoding {
    static func decodePhonemePairs<K: CodingKey>(from container: KeyedDecodingContainer<K>, forKey key: K) throws -> [(Phoneme?, Phoneme?)] {
        let phonemeArrays = try container.decode([[Phoneme?]].self, forKey: key)
        return try phonemeArrays.map { array in
            guard array.count == 2 else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: container,
                    debugDescription: "Expected a phoneme pair, got \(array)")
            }
            return (array[0], array[1])
        }
    }
}
