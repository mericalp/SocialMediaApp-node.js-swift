//
//  ProfileViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var user: User
    
    init(user: User) {
        self.user = user
        fetchPosts()
        checkIfIsCurrentUser()
        checkIfUserIsFollowed()
    }
    
    func fetchPosts() {
        RequestService.requestDomain = "http://localhost:3000/tweets/\(self.user.id)"
        RequestService.fetchData { res in
            switch res {
                case .success(let data):
                    guard let posts = try? JSONDecoder().decode([Post].self, from: data as! Data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func uploadProfileImage(text: String, image: UIImage?) {
        guard let user = AuthViewModel.shared.currentUser else { return }
        if let image = image {
            ImageUploader.uploadImage(paramName: "avatar", fileName: "image1", image: image, urlPath: "/users/me/avatar")
        }
    }
    
    func follow() {
        guard let authedUser = AuthViewModel.shared.currentUser else { return }
        RequestService.requestDomain = "http://localhost:3000/users/\(self.user.id)/follow"
        RequestService.followingProcess(id: self.user.id) { result in
            print(result)
            print("Followed")
        }
        RequestService.requestDomain = "http://localhost:3000/notification"
        RequestService.sendNotification(username: authedUser.username, notSenderId: authedUser.id, notReceiverId: self.user.id, notificationType: NotificationType.follow.rawValue, postText: "") { result in
            print("FOLLOWED")
            print(result)
        }
        print("Followed")
        self.user.isFollowed = true
    }
    
    func unfollow() {
        RequestService.requestDomain = "http://localhost:3000/users/\(self.user.id)/unfollow"
        RequestService.followingProcess(id: self.user.id) { result in
            print(result)
            print("Unfollowed")
        }
        print("Unfollowed")
        self.user.isFollowed = false
    }
    
    func checkIfUserIsFollowed() {
        if (self.user.followers.contains(AuthViewModel.shared.currentUser!._id)) {
            self.user.isFollowed = true
        } else {
            self.user.isFollowed = false
        }
    }
    
    func checkIfIsCurrentUser() {
        if (self.user._id == AuthViewModel.shared.currentUser?._id) {
            self.user.isCurrentUser = true
        }
    }
    
    
    
}
