//
//  NavigationStack.swift
//  ParrotIos
//
//  Created by Tom Smail on 04/02/2025.
//

import SwiftUI


// User Board View
struct UserBoardView: View {
    var body: some View {
        VStack {
            Text("User Board")
                .font(.largeTitle)
                .padding()

            Image(systemName: "person.3.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
        }
    }
}

// Main Navigation View
struct ContentView: View {
    var body: some View {
        TabView {
            RecordingView()
                .tabItem {
                    Label("Recording", systemImage: "mic")
                }
            UserBoardView()
                .tabItem {
                    Label("User Board", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
