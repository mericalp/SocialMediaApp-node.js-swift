//
//  EditProfileViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI

class EditProfileViewModel: ObservableObject {
    
    var user: User
    @Published var uploadComplete = false
    
    init(user: User) {
        self.user = user
    }
    
    func save(name: String?, bio: String?, website: String?, location: String?) {
        guard let userNewName = name else { return }
        guard let userNewWebsite = website else { return }
        guard let userNewLocation = location else { return }
        self.user.name = userNewName
        self.user.bio = bio
        self.user.website = userNewWebsite
        self.user.location = userNewLocation
    }
    
    func uploadProfileImage(text: String, image: UIImage?) {
        guard let user = AuthViewModel.shared.currentUser else { return }
        let urlPath = "/users/me/avatar"
        if let image = image {
            print("There is an image")
            ImageUploader.uploadImage(paramName: "avatar", fileName: "image1", image: image, urlPath: urlPath)
        }
    }
    
    func uploadUserData(name: String?, bio: String?, website: String?, location: String?) {
        let userId = user.id
        let urlPath = "/users/\(userId)"
        let url = URL(string: "http://localhost:3000\(urlPath)")!
        AuthService.makeRequestWithAuth(urlString: url, reqBody: ["name": name, "bio": bio, "website": website, "location": location]) { res in
            DispatchQueue.main.async {
                self.save(name: name, bio: bio, website: website, location: location)
                self.uploadComplete = true
            }
        }
    }
}
