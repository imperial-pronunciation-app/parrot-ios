//
//  CurriculumView.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//
import SwiftUI

// Curriculum View
struct CurriculumView: View {
    let viewModel = ViewModel()
    
    private func errorView(errorMessage: String) -> some View {
        VStack {
            Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading...")
            .scaleEffect(1.5, anchor: .center)
            .padding()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.errorMessage {
                    errorView(errorMessage: error)
                } else {
                    ForEach(viewModel.curriculum!.units) { unit in
                        VStack {
                            Text(unit.name).font(.headline)
                            UnitView(unit: unit)
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding()
        }.onAppear{
            Task {
                await viewModel.loadCurriculum()
            }
        }
    }
}

#Preview {
    CurriculumView()
}
