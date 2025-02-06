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
    @State private var passwordField = ""
    @State private var confirmPasswordField = ""
    @State private var succeed = false
    
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
                SecureField("Confirm Password", text: $confirmPasswordField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                
                Button("Register") {
                    Task {
                        await viewModel.register(email: emailField, password: passwordField, confirmPassword: confirmPasswordField, succeed: $succeed)
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
            .navigationDestination(isPresented: $succeed) {
                NavigationView().navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
