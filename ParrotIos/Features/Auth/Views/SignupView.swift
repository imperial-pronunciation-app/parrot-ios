//
//  SignupView.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import SwiftUI

struct SignupView: View {

    @State private var viewModel = ViewModel()
    @State private var emailField = ""
    @State private var displayNameField = ""
    @State private var passwordField = ""
    @State private var confirmPasswordField = ""
    @State private var succeed = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Create account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom)

                TextField("Email", text: $emailField)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                TextField("Display Name", text: $displayNameField)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $passwordField)
                    .textFieldStyle(.roundedBorder)

                SecureField("Confirm Password", text: $confirmPasswordField)
                    .textFieldStyle(.roundedBorder)

                Button(action: {
                    Task {
                        await viewModel.register(
                            email: emailField,
                            displayName: displayNameField,
                            password: passwordField,
                            confirmPassword: confirmPasswordField,
                            succeed: $succeed
                        )
                    }
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Sign Up")
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical)
                .buttonStyle(.borderedProminent)

                NavigationLink(destination: LoginView()) {
                    Text("Already have an account?")
                        .foregroundStyle(.gray)
                    Text("Login")
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignupView()
}
