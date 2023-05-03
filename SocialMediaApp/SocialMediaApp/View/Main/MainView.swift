//
//  MainView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//

import SwiftUI

struct MainView: View {
    let user: User
    
    var body: some View {
            VStack {
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                    VStack {
                        TabBar(user: user)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
}


