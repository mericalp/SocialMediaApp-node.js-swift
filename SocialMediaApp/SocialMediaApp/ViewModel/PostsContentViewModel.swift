//
//  PostsContentViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//

import SwiftUI

class PostsContentViewModel: ObservableObject {
    
    func uploadPost(text: String, image: UIImage?) {
        guard let user = AuthViewModel.shared.currentUser else { return }
        RequestService.requestDomain = "http://localhost:3000/posts"
        
        RequestService.postContent(text: text, user: user.name, username: user.username, userId: user.id) { result in
            if let image = image {
                if let id = result?["_id"]! {

                }
            }
        }
    }
    
}
