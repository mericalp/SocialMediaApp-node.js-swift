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
    @State var clap = false
    
    
    init(post: Post, currentUser: User) {
        self.post = post
        self.currentUser = currentUser
        
        self.fetchUser(userId: post.user)
        self.checkIfIsCurrentUser()
        self.checkIfUserClapPost()
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
    
    func clapPost() {
        RequestService.requestDomain = "http://localhost:3000/posts/\(self.post.id)/like"
        
        RequestService.clapPost(id: self.post.id) { result in
            print("posts has been clapp")
            print("Console log: \(result)")
            
        }
        RequestService.requestDomain = "http://localhost:3000/notification"
        RequestService.sendNotification(username: self.currentUser.username, notSenderId: self.currentUser.id, notReceiverId: self.post.userId, notificationType: NotificationType.clap.rawValue, postText: self.post.text) { result in
            print(result)
        }
        self.post.didClap = true
    }
    
    func unclapPost() {
        RequestService.requestDomain = "http://localhost:3000/posts/\(self.post.id)/unlike"
        RequestService.clapPost(id: self.post.id) { result in
            print("Tweet has been unclapp")
            
            
        }
        self.post.didClap = false
    }
    
    func checkIfUserClapPost() {
        if (self.post.likes.contains(self.currentUser.id)) {
            self.post.didClap = true
        }
        else {
            self.post.didClap = false
        }
    }
    func checkIfIsCurrentUser() {
        if (self.user?._id == AuthViewModel.shared.currentUser?._id) {
            self.user?.isCurrentUser = true
        }
    }
    
}
