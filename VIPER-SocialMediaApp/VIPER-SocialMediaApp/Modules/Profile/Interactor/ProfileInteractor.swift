//
//  ProfileInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 25.05.2023.
//

import Foundation

protocol ProfileInteractorProtocol2: class {
    func fetchUsers()
    func loadPost()
}

enum ProfileInteractorOutput {
    case setLoading(Bool)
    case showUser(User)
    case showPosts([Post])
}

protocol ProfileInteractorDelegate: class {
    func handleOutput(_ output: ProfileInteractorOutput)
}

class ProfileInteractor: ProfileInteractorProtocol2 {
    weak var delegate: ProfileInteractorDelegate?
    private let service: NetworkManager
    private var posts: [Post] = []

    init(service: NetworkManager) {
        self.service = service
    }
    
    func fetchUsers() {
        delegate?.handleOutput(.setLoading(true))
        let userId = LocalState.userId as! String
        NetworkManager.fetchUser(id: userId) { result in
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data ?? Data()) else {
                    return
                }
                self.delegate?.handleOutput(.showUser(user))
             case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadPost() {
        NetworkManager().fetchPosts { result in
            switch result {
            case .success(let data):
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    self.posts = posts
                    self.delegate?.handleOutput(.showPosts(posts))
                    
                } catch { }
            case .failure(let error):
                print("error")
            }
        }
    }
    
}

