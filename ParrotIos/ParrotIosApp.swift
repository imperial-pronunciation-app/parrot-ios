//
//  ParrotIosApp.swift
//  ParrotIos
//
//  Created by Pedro Sá Fontes on 22/01/2025.
//

import SwiftUI
import SwiftData

@main
struct ParrotIosApp: App {
    @StateObject private var authService = AuthService.instance

    var body: some Scene {
        WindowGroup {
            if authService.isAuthenticated {
                NavigationView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    NavigationView()
}
