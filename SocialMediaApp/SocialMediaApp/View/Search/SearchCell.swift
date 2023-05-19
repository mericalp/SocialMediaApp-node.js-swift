//
//  SearchCell.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import SwiftUI
import Kingfisher

struct SearchUserCell: View {
    let user: User
    @StateObject private var profileImageLoader = ImageLoader()

    var body: some View {
        let imageURL =  URL(string:"\(Path.baseUrl)\(Path.users.rawValue)/\(self.user.id)/avatar")!
        HStack {
            profileImageLoader.image?
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(user.name)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Text(user.username)
                    .foregroundColor(.black)
            }
            Spacer(minLength: 0)
        }
        .onAppear {
            profileImageLoader.loadImage(from: imageURL)
        }
    }
}


//struct SearchCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchCell()
//    }
//}
