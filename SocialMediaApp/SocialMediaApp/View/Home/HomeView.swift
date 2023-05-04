//
//  HomeView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    let user: User
    
    var body: some View {
        RefreshableScrollView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 18) {
                    ForEach(viewModel.posts) { post in
                        PostCell(viewModel: PostCellViewModel(post: post, currentUser: user))
                        Divider()
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }onRefresh: { control in
            DispatchQueue.main.async {
                self.viewModel.fetchTweets()
                control.endRefreshing()
            }
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
