//
//  TabBar.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//

import SwiftUI

struct TabBar: View {
    @State var showCreatePost = false
    @State var selectedIndex = 0
    
    let user: User
    
    var body: some View {
        VStack {
            ZStack {
                TabView {
                    HomeView(user: user)
                        .onTapGesture {
                            selectedIndex = 0
                        }.navigationBarHidden(true)
                        .navigationBarTitle("")
                        .tabItem {
                            Image(systemName: "house")
                        }.tag(0)
                    SearchView()
                        .onTapGesture {
                            selectedIndex = 1
                        }.navigationBarHidden(true)
                        .navigationBarTitle("")
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }.tag(1)
                    NotificationView(user: user)
                        .onTapGesture {
                            selectedIndex = 2
                        }.navigationBarHidden(true)
                        .navigationBarTitle("")
                        .tabItem {
                            Image(systemName: "bell")
                        }.tag(2)
                    ProfileView(user: user)
                        .onTapGesture {
                            selectedIndex = 3
                        }.navigationBarHidden(true)
                        .navigationBarTitle("")
                        .tabItem {
                            Image(systemName: "person")
                        }.tag(3)
                }
                .accentColor(Color.peach)
                .edgesIgnoringSafeArea(.top)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showCreatePost.toggle()
                        }) {
                            Image(systemName: "wand.and.rays").renderingMode(.template).resizable().frame(width: 20, height: 20).padding()
                        }.background(Color.peach)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: Color.peach, radius: 5)
                        .zIndex(5)
                    }.padding()
                }.padding(.bottom,65)
            }
            .sheet(isPresented: $showCreatePost) {
                CreatePostView(show: self.$showCreatePost, user: user)
            }
        }
        // for drag gesture...
        .contentShape(Rectangle())
        .background(Color.white)
    }
}

//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}
