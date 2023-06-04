//
//  EditProfileInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import UIKit

enum EditProfilInteractorOutput {
    case dismiss
}

protocol EditProfileInteractorProtocol: AnyObject {
    func update(name: String, location: String)
    func uploadProfileImage(text: String, image: UIImage?)
}

protocol EditProfilInteractorDelegate: AnyObject {
    func handleOutput(_ output: EditProfilInteractorOutput)
}

class EditProfileInteractor: EditProfileInteractorProtocol {
    weak var delegate: EditProfilInteractorDelegate?
    private let service: NetworkManager
    var uploadComplete: Bool = false
    var user: User
    
    init(service: NetworkManager, user: User) {
        self.service = service
        self.user = user
    }
    
    func save(name: String, location: String) {
        self.user.name = name
        self.user.location = location
        print("dd")
        print(name)
        print(location)
    }
    
    func update(name: String, location: String) {
        let userId = LocalState.userId as! String
        guard let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)\("/")\(userId)") else { return   }
        NetworkManager.updateProfile(url: url, method: .patch, reqBody: ["name": name, "location": location]) { result in
            DispatchQueue.main.async {
                self.save(name: name, location: location)
                print("dda")
                print(name)
                print(location)
            }
        }
    }
    
    func uploadProfileImage(text: String, image: UIImage?) {
        let urlPath = "\(Path.avatar.rawValue)"
        if let image = image {
            ImageUploader.uploadImage(paramName: "avatar", fileName: "image1", image: image, urlPath: urlPath)
            print("images interactor")
            print(image)
        }
    }
    
}


