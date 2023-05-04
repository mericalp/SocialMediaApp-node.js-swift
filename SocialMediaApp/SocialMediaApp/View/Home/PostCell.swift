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
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10){
              if let user = viewModel.user {
                    NavigationLink { } label: {
                        KFImage(URL(string: "http://localhost:3000/users/\(self.viewModel.post.userId)/avatar"))
                            .resizable()
                            .background(Color.peach)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .padding(.leading, 8)
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
                      if viewModel.post.image == "true" {
                          GeometryReader { proxy in
                              KFImage(URL(string: "http://localhost:3000/posts/\(imageId)/image"))
                                  .resizable()
                                  .background(Color.peach)
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: proxy.frame(in: .global).width, height: 250)
                                  .cornerRadius(15)
                          }
                          .frame(height: 250)
                      }
                  }
                }
                Spacer()
            }
            
            HStack(spacing : 40) {
                Button { } label: {
                    Image(systemName: "lasso").resizable().frame(width: 21, height: 21)
                }.foregroundColor(.black)
                
                Button {
//                if (self.didLike) {
//                    print("it has not been  clapp")
//                    viewModel.unclapPost()
//                } else {
//                    print("it has been clapp")
//                    viewModel.clapPost()
//                }
                } label: {
//                  if (self.didLike == false) {
//                      Image(systemName: "hands.clap").resizable().frame(width: 18, height: 15)
//                  } else {
                        Image(systemName: "hands.clap.fill").resizable().frame(width: 24, height: 24).offset(y: -2)
//                  }
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
}

//struct HomeViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCell()
//    }
//}
