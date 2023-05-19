//
//  TabBar.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//
import SwiftUI

struct TabBar: View {
    @ObservedObject var vm: NotificationViewModel
    @State var showCreatePost = false
    @State var selectedIndex = 0
    @State private var badgeCount = 0
    let user: User

    init(user: User) {
        self.user = user
        self.vm =  NotificationViewModel(user: user)
    }

    fileprivate func wandandraysFunc() -> VStack<TupleView<(Spacer, some View)>> {
        return VStack {
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
        }
    }

    var body: some View {
        VStack {
            ZStack {
                TabBarView(user: user, vm: vm)
                wandandraysFunc().padding(.bottom,65)
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

struct TabBarView: View {
    let user: User
    @State var selectedIndex = 0
    @State private var badgeCount = 0
    @ObservedObject var vm: NotificationViewModel
    
    var body: some View {
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
                .onReceive(vm.$notiCount) { count in
                    badgeCount = count
                }
                .badge(badgeCount)
                .onTapGesture {
                    selectedIndex = 2
                }.navigationBarHidden(true)
                .navigationBarTitle("")
                .tabItem {
                    Image(systemName: "bell")
                }.tag(2)
            ProfileView(user: user).environmentObject(AuthViewModel.shared)
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
    }
}


//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}
