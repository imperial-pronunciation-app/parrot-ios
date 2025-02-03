//
//  LoginView.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel = AuthViewModel()
    @State private var usernameField = ""
    @State private var passwordField = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $usernameField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.bottom, 10)
            
            SecureField("Password", text: $passwordField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            
            Button("Login") {
                Task {
                    await viewModel.login(username: usernameField, password: passwordField)
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            Button("Logout") {
                Task {
                    await viewModel.logout()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
