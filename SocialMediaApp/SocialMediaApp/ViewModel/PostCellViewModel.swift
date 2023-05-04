//
//  PostCellViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import Foundation
import SwiftUI

class PostCellViewModel: ObservableObject {
    @Published var post: Post
    @Published var user: User?
    let currentUser: User
    @State var liked = false
    
    
    init(post: Post, currentUser: User) {
        self.post = post
        self.currentUser = currentUser
        
        self.fetchUser(userId: post.user)
        
    }
    
    func fetchUser(userId: String) {
        AuthService.requestDomain = "http://localhost:3000/users/\(userId)"
        
        AuthService.fetchUser(id: userId) { res in
            switch res {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data as! Data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.user = user
                    print(user)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
