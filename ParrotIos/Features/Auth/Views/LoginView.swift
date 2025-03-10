//
//  LoginView.swift
//  ParrotIos
//
//  Created by jn1122 on 02/02/2025.
//

import SwiftUI

struct LoginView: View {

    @State private var viewModel: ViewModelProtocol
    @State private var emailField = ""
    @State private var passwordField = ""
    @State private var succeed = false

    internal var didAppear: ((Self) -> Void)?

    init(viewModel: ViewModelProtocol = ViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image("parrot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 128, height: 128)

                Text("Welcome back!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom)

                TextField("Email", text: $emailField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Password", text: $passwordField)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    Task {
                        await viewModel.login(email: emailField, password: passwordField, succeed: $succeed)
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)

                NavigationLink(destination: SignupView()) {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    Text("Sign up")
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding(.horizontal, 32)
        }
        .navigationBarBackButtonHidden()
        .onAppear { self.didAppear?(self) }
    }
}

#Preview {
    LoginView()
}
