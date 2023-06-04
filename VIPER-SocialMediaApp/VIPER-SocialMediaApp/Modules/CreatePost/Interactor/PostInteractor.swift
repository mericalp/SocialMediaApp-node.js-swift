//
//  PostInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 31.05.2023.
//

import Foundation
import UIKit

// MARK: - Interactor
protocol PostCreateInteractorProtocol {
    func postcontent(text: String, image: UIImage?, user: User)
    func fetchCurrentUser()
}

enum PostCreateInteractorOutput {
    case getCurrentUser(User)
}

protocol PostCreateInteractorDelegate: AnyObject {
    func handleOutput(_ output: PostCreateInteractorOutput)
}

class PostCreateInteractor: PostCreateInteractorProtocol {
    weak var delegate: PostCreateInteractorDelegate?
    
    func postcontent(text: String, image: UIImage?, user: User) {
        NetworkManager.postContent(text: text, user: user.name, username: user.username, userId: user.id) { result in
            if let image = image {
                if let id = result?["_id"]! {
                    let path = "\(Path.uploadPostImage.rawValue)\(id)"
                    ImageUploader.uploadImage(paramName: "upload", fileName: "image1", image: image, urlPath: path)
                }
            }
        }
    }
    
    //TODO: -
    func fetchCurrentUser() {
        let userId = LocalState.userId as! String
        NetworkManager.fetchUser(id: userId) { result in
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data ?? Data()) else {
                    return
                }
                self.delegate?.handleOutput(.getCurrentUser(user))
             case .failure(let error):
                print(error)
            }
        }
    }

}
