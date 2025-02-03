//
//  LoginView.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.bottom, 10)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            
            Button("Login") {
                Task {
                    await viewModel.login(email: email, password: password)
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
                    let success = await AuthService.shared.logout()
                    if success {
                        print("Logged out successfully.")
                    } else {
                        print("Logout failed.")
                    }
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
