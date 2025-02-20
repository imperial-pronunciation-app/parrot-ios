//
//  WordOfTheDayView.swift
//  ParrotIos
//
//  Created by Henry Yu on 20/2/2025.
//

import SwiftUI

struct WordOfTheDayView: View {
    
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel = ViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
