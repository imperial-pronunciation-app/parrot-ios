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

    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    UtilComponents.loadingView
                } else if let error = viewModel.errorMessage {
                    UtilComponents.errorView(errorMessage: error)
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
        }.onAppear {
            Task {
                await viewModel.loadCurriculum()
            }
        }
    }
}
