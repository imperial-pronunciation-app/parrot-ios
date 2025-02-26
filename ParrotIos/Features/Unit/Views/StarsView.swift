//
//  StarsView.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 26/02/2025.
//
import SwiftUI

struct StarsView: View {
    let filledStars: Int

    var body: some View {
        VStack(alignment: .center) {
            starIcon(index: 0)
            HStack(spacing: 2) {
                starIcon(index: 1)
                starIcon(index: 2)
            }
        }
    }

    @ViewBuilder
    private func starIcon(index: Int) -> some View {
        Image(systemName: index < filledStars ? "star.fill" : "star")
            .foregroundColor(index < filledStars ? .accentColor : .gray)
            .font(.system(size: 12))
    }
}
