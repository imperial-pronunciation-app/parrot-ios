//
//  LoginView.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import SwiftUI

enum AppScreen: Hashable {
    case login
    case mainPage
}

struct LoginView: View {

    @State private var viewModel = ViewModel()
    @State private var usernameField = ""
    @State private var passwordField = ""
    @State private var succeed = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Username", text: $usernameField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.bottom, 8)
                SecureField("Password", text: $passwordField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 16)
                
                Button("Login") {
                    Task {
                        await viewModel.login(username: usernameField, password: passwordField, succeed: $succeed)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .underline()
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 32)
            .navigationDestination(isPresented: $succeed) {
                NavigationView().navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
