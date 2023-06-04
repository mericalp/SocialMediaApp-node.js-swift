//
//  SearchProfileInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import Foundation


protocol UserDetailInteractorProtocol: class {
    func follow(userId: String)
    func unfollow(userId: String)
    func loadUser(userId: String)
    func loadPost()

}

enum UserDetailInteractorOutput {
    case setLoading(Bool)
    case showUser(User)
    case buttonUpdateTitle(Bool)
    case showPosts([Post])

}

protocol UserDetailInteractorDelegate: class {
    func handleOutput(_ output: UserDetailInteractorOutput)
}

class UserDetailInteractor: UserDetailInteractorProtocol {
    private let service: NetworkManager
    weak var delegate: UserDetailInteractorDelegate?
    var uploadComplete: Bool = false
    var user: User
    private var posts: [Post] = []

    init(service: NetworkManager, user: User) {
        self.service = service
        self.user = user
    }
    
    func save(name: String, location: String) {
        self.user.name = name
        self.user.location = location
    }
    
    func follow(userId: String) {
        guard let url = URL(string:  "\(Path.baseUrl)\(Path.users.rawValue)/\(userId)/\(Path.follow.rawValue)") else { return }
        
        NetworkManager().followingProcess(url: url, id: self.user.id) { result in
            self.user.isFollowed = true
            self.delegate?.handleOutput(.buttonUpdateTitle(self.user.isFollowed!))
            let authUserId = LocalState.userId as! String
            NetworkManager.sendNotification(username: self.user.name, notSenderId: authUserId, notReceiverId: userId, notificationType:NotificationType.follow.rawValue, postText: "") { result in
            }
        }
    }
    
    func unfollow(userId: String) {
        guard let url = URL(string:  "\(Path.baseUrl)\(Path.users.rawValue)/\(userId)/\(Path.unfollow.rawValue)") else { return }
        
        NetworkManager().followingProcess(url: url, id: self.user.id) { result in
            self.user.isFollowed = false
            self.delegate?.handleOutput(.buttonUpdateTitle(self.user.isFollowed!))
        }
    }
    
    func loadUser(userId: String) {
        delegate?.handleOutput(.setLoading(true))
        
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
