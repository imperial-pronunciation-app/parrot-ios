//
//  SignupView.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import SwiftUI

struct SignupView: View {

    @State private var viewModel = SignupViewModel()
    @State private var emailField = ""
    @State private var passwordField = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $emailField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 10)
                SecureField("Password", text: $passwordField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                
                Button("Register") {
                    Task {
                        await viewModel.register(email: emailField, password: passwordField)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink(destination: LoginView()) {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                        .underline()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}
