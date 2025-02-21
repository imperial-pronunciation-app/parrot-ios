//
//  RecapLockedView.swift
//  ParrotIos
//
//  Created by et422 on 19/02/2025.
//

import SwiftUI

struct RecapLockedView: View {

    var body: some View {
        HStack {
            Text("Recap")
                .font(.subheadline)
                .padding(.bottom, 2)
            
            Spacer()
            Image(systemName: "lock.fill")
                .foregroundColor(.black)
                .font(.title2)
            
        }
        .padding()
        .background( Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
