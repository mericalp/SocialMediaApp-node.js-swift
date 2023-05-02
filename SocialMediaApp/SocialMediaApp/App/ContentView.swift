//
//  ContentView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 26.04.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = AuthViewModel()

    var body: some View {
        if viewModel.isAuthenticated {
            if let user = viewModel.currentUser {
                HomeView()
            }
        }
        else {
            WelcomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
