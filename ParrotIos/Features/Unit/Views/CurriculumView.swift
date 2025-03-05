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
        NavigationStack {
            ScrollView {
                VStack {
                    if viewModel.isLoading {
                        UtilComponents.loadingView
                    } else if let error = viewModel.errorMessage {
                        UtilComponents.errorView(errorMessage: error)
                    } else {
                        ForEach(Array(viewModel.curriculum!.units.enumerated()), id: \.element.id) { index, unit in
                            let isLast = index == viewModel.curriculum!.units.count - 1
                            let isNextCompleted = !isLast &&
                                viewModel.curriculum!.units[index + 1].isCompleted
                            UnitView(unit: unit, isLast: isLast, isNextCompleted: isNextCompleted)
                        }
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .top) {
                // Pinned Header
                HStack {
                    Image("en-US")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    
                    Text("Curriculum")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(viewModel.streaks())")
                            .font(.headline)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .overlay(Divider(), alignment: .bottom)
            }
        }.onAppear {
            Task {
                await viewModel.loadCurriculum()
            }
        }
    }
}
