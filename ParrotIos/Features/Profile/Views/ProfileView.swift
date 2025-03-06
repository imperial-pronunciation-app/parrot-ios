//
//  ProfileView.swift
//  ParrotIos
//
//  Created by James Watling on 05/03/2025.
//

import SwiftUI

struct ProfileView: View {
    let viewModel = ViewModel()
    @State private var nameField: String
    @State private var emailField: String
    @State private var languageSelection: Int

    init() {
        nameField = viewModel.userDetails?.displayName ?? ""
        emailField = viewModel.userDetails?.email ?? ""
        languageSelection = viewModel.userDetails?.language.id ?? 0
    }

    private func colourFor(league: String?) -> Color {
        if league == nil {
            return Color.gray
        }

        switch league {
        case "Bronze":
            return Color(red: 0.8, green: 0.5, blue: 0.2)
        case "Silver":
            return Color.gray
        case "Gold":
            return Color.orange
        default:
            return Color.gray
        }
    }

    var body: some View {
        VStack {
            Text("Your Profile")
                .font(.headline)
                .bold()
                .padding(.bottom, 32)
            Image("blue-bird")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.bottom, 8)
            HStack(spacing: 30) {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(.yellow)
                    Text("\(viewModel.userDetails?.xpTotal ?? 0)")
                        .bold()
                    Text("XP")
                        .foregroundStyle(.gray)
                }

                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(colourFor(league: viewModel.userDetails?.league))
                    Text(viewModel.userDetails?.league ?? "League")
                        .bold(viewModel.userDetails?.league != nil)
                        .foregroundStyle(viewModel.userDetails?.league == nil ? .gray : .primary)
//                    Text("League")
//                        .foregroundStyle(.gray)
                }

                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.accent)
                    Text("\(viewModel.userDetails?.loginStreak ?? 0)")
                        .bold()
                    Text("Days")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 20)
            Form {
                Section {
                    LabeledContent("Name") {
                        TextField("Name", text: $nameField)
                    }
                    LabeledContent("Email") {
                        TextField("Email", text: $emailField)
                    }
                    Picker("Language", selection: $languageSelection) {
                        ForEach(viewModel.languages) { language in
                            Text(language.name)
                                .tag(language.id)
                        }
                    }
                } header: {
                    Text("Account Details")
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))
            }
            .background(Color(UIColor.systemBackground))
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            .frame(height: 180)

            Button(action: {
                Task {
                    try await viewModel.updateDetails(name: nameField, email: emailField, languageCode: languageSelection)
                }
            }) {
                Text("Update Details")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)

            Spacer()

            Button(action: {
                Task {
                    try await viewModel.logout()
                }
            }) {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
            }
            .tint(.secondary)
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
            .padding(.bottom)
        }
        .onAppear(perform: {
            Task {
                try await viewModel.onLoad()
            }
        })
    }
}

#Preview {
    ProfileView()
}
