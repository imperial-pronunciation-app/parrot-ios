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
    @State private var showToast = false

    init() {
        nameField = viewModel.userDetails.displayName
        emailField = viewModel.userDetails.email
        languageSelection = viewModel.userDetails.language.id
    }

    private func colourFor(league: String) -> Color {
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
        ZStack {
            VStack {
                Text("Your Profile")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 32)
                    .padding(.top, 4)
                getAvatar(for: viewModel.userDetails.avatar, size: 100)
                    .padding(.bottom, 8)
                HStack(spacing: 32) {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .foregroundStyle(.yellow)
                        Text("\(viewModel.userDetails.xpTotal)")
                            .bold()
                        Text("XP")
                            .foregroundStyle(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(colourFor(league: viewModel.userDetails.league))
                        Text(viewModel.userDetails.league)
                            .bold()
                            .foregroundStyle(.primary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.accent)
                        Text("\(viewModel.userDetails.loginStreak)")
                            .bold()
                        Text("Days")
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 20)
                Form {
                    Section {
                        LabeledContent("Name") {
                            TextField("", text: $nameField)
                                .multilineTextAlignment(.trailing)
                        }
                        LabeledContent("Email") {
                            TextField("", text: $emailField)
                                .multilineTextAlignment(.trailing)
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
                        try await viewModel.updateDetails(
                            name: nameField,
                            email: emailField,
                            languageCode: languageSelection
                        )
                        
                        withAnimation {
                            showToast = true
                        }
                        // Hide the toast after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
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
            
            if showToast {
                VStack {
                    Toast(message: "Your details have been updated.")
                    Spacer()
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showToast)
            }
        }
    }
}

struct Toast: View {
    let message: String

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.white)
                .font(.title3)
            Text(message)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.green.brightness(0.1))
        .cornerRadius(8)
        .frame(width: .infinity)
    }
}
