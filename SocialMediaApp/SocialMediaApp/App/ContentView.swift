//
//  ContentView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 26.04.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.isAuthenticated {
            if let user = viewModel.currentUser {
                TabBar(user: user)
            }
        } else {
            WelcomeView().environmentObject(AuthViewModel.shared)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
