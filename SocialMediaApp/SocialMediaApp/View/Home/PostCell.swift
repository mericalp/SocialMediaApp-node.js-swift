//
//  HomeViewCell.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI
import Kingfisher

struct PostCell: View {
    @ObservedObject var viewModel: PostCellViewModel

    init(viewModel: PostCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            UserInfoCellView(viewModel: viewModel)
            ContentFooter(viewModel: viewModel)
        }
    }
}

struct UserInfoCellView: View {
    @ObservedObject var viewModel: PostCellViewModel
    @StateObject private var profileImageLoader = ImageLoader()
    @StateObject private var postImageLoader = ImageLoader()
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let user = viewModel.user {
                let profileImage = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(self.viewModel.post.userId)/avatar")!
                NavigationLink { } label: {
                    profileImageLoader.image?
                        .resizable()
                        .background(Color.peach)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .padding(.leading, 8)
                }
                .onAppear {
                    profileImageLoader.loadImage(from: profileImage)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("\(viewModel.post.username) ")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text("@\(viewModel.post.username)")
                    .foregroundColor(.gray)
                Text(viewModel.post.text)
                
                if let imageId = viewModel.post.id {
                    let postImage = URL(string: "\(Path.baseUrl)\(Path.post.rawValue)/\(imageId)/image")!
                    if viewModel.post.image == "true" {
                        GeometryReader { proxy in
                            postImageLoader.image?
                                .resizable()
                                .background(Color.peach)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: proxy.frame(in: .global).width, height: 250)
                                .cornerRadius(15)
                        }
                        .frame(height: 250)
                        .onAppear {
                            postImageLoader.loadImage(from: postImage)
                        }
                    }
                }
            }
        Spacer()
        }
        
    }
}


struct ContentFooter: View {
    @ObservedObject var viewModel: PostCellViewModel
    var didClap: Bool { return viewModel.post.didClap ?? false }

    var body: some View {
        HStack(spacing : 40) {
            Button { } label: {
                Image(systemName: "lasso").resizable().frame(width: 21, height: 21)
            }.foregroundColor(.black)
            
            Button {
                if (self.didClap) {
                    print("it has not been  clapp")
                    viewModel.unclapPost()
                } else {
                    print("it has been clapp")
                    viewModel.clapPost()
                }
            } label: {
                if (self.didClap == false) {
                    Image(systemName: "hands.clap").resizable().frame(width: 24, height: 24).offset(y: -2)
                } else {
                    Image(systemName: "hands.clap.fill").resizable().frame(width: 24, height: 24).offset(y: -2)
                }
            }.foregroundColor(.black)
            
            Button { } label: {
                Image(systemName: "bookmark").resizable().renderingMode(.template).frame(width: 17, height: 18).offset(x: 2)
            }.foregroundColor(.black)
            
            Button { } label: {
                Image(systemName: "link").resizable().renderingMode(.template).frame(width: 21, height: 21)
            }.foregroundColor(.black)
        }
    }
}



//struct HomeViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCell()
//    }
//}
