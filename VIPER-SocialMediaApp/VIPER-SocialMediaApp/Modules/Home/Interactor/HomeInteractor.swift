//
//  Interactor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 21.05.2023.
//

import Foundation

protocol HomeInteractorProtocol: AnyObject {
    func loadPost()
    func selectUser(at index: Int)
}

enum HomeInteractorOutput {
    case setLoading(Bool)
    case showPosts([Post])
    case showUserDetail(String)
}

protocol HomeInteractorDelegate: AnyObject {
    func handleOutput(_ output: HomeInteractorOutput)
}

class HomeInteractor: HomeInteractorProtocol {
    weak var delegate: HomeInteractorDelegate?
    private let service: NetworkManager
    private var posts: [Post] = []
    
    init(service: NetworkManager) {
        self.service = service
    }
    
    func loadPost() {
        service.fetchPosts { result in
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
    
    func selectUser(at index: Int) {
        let post = posts[index]
        print(post)
        delegate?.handleOutput(.showUserDetail(post.userId))
    }
    
    func clapPost(post: Post) {
        var updatePost = post
        updatePost.didClap = true
        NetworkManager.clapPost(id: updatePost.id) { result in }
        var userid = (LocalState.userId as? String)!
        NetworkManager.sendNotification(username: updatePost.username, notSenderId: userid, notReceiverId: post.userId, notificationType: NotificationType.clap.rawValue, postText: post.text) { result in }
    }
    
    func unclapPost(post: Post) {
        var updatePost = post
        updatePost.didClap = false
        NetworkManager.unclapPost(id: updatePost.id) { result in }
    }
    
    func checkIfUserClapPost(posts: [Post]) -> [Post] {
        let currentUser = (LocalState.userId as? String)!
          var updatedPosts: [Post] = []

          for var post in posts {
              if post.likes.contains(currentUser) {
                  post.didClap = true
              } else {
                  post.didClap = false
              }
              updatedPosts.append(post)
          }
          return updatedPosts
    }
    
}
