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
    
    
}
