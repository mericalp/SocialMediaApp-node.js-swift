//
//  EditProfileViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI

class EditProfileViewModel: ObservableObject {
    @Published var uploadComplete = false
    var user: User
    
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
        let urlPath = "\(Path.avatar.rawValue)"
        if let image = image {
            print("There is an image")
            ImageUploader.uploadImage(paramName: "avatar", fileName: "image1", image: image, urlPath: urlPath)
        }
    }
    
    func uploadUserData(name: String?, bio: String?, website: String?, location: String?) {
        let userId = user.id
        let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)\("/")\(userId)")
        AuthService.makeRequestWithAuth(url: url!, method: .patch, reqBody: ["name": name, "bio": bio, "website": website, "location": location]) { res in
            DispatchQueue.main.async {
                self.save(name: name, bio: bio, website: website, location: location)
                self.uploadComplete = true
            }
        }
    }
}
