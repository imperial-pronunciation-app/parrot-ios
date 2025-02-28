//
//  WordView.swift
//  ParrotIos
//
//  Created by James Watling on 28/02/2025.
//

import SwiftUI

struct WordView: View {
    let word: Word

    public var body: some View {
        VStack {
            Text(word.text).font(.largeTitle)
            Text(word.phonemes
                .compactMap { $0.respelling }
                .joined(separator: "."))
            .font(.title)
            .foregroundColor(Color.gray)
        }
    }
}
