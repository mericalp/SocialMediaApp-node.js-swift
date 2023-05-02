//
//  SocialMediaAppApp.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 26.04.2023.
//

import SwiftUI

@main
struct SocialMediaAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
               ContentView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
