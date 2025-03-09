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
                            let isFirst = index == 0
                            let isNextCompleted = !isLast &&
                                viewModel.curriculum!.units[index + 1].isCompleted
                            let isPrevCompleted = !isFirst &&
                                viewModel.curriculum!.units[index - 1].isCompleted
                            UnitView(
                                unit: unit,
                                isFirst: isFirst,
                                isLast: isLast,
                                isPrevCompleted: isPrevCompleted,
                                isNextCompleted: isNextCompleted,
                                callback: { await viewModel.loadCurriculum() })
                        }
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .top) {
                // Pinned Header
                HStack {
                    Image(viewModel.userDetails.language.code)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Curriculum")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Spacer()
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .foregroundStyle(.yellow)
                            Text("\(viewModel.userDetails.xpTotal)")
                                .bold()
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.accent)
                            Text("\(viewModel.streaks())")
                                .font(.headline)
                        }
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
        }.onReceive(NotificationCenter.default.publisher(for: .didDismissExerciseView)) { _ in
            Task {
                await viewModel.loadCurriculum()
            }
        }
    }
}
