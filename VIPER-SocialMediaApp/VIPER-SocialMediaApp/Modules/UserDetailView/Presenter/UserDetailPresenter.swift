//
//  SearchPresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import Foundation

enum UserDetailPresenterOutput {
    case setLoading(Bool)
}

protocol UserDetailPresenterProtocol: class {
    func viewDidLoad()
    func follow(userId: String)
    func unfollow(userId: String)
    func loadUser(userId: String)
}

class UserDetailPresenter: UserDetailPresenterProtocol {
    let view: UserDetailViewController
    private let interactor: UserDetailInteractorProtocol
    
    init (view: UserDetailViewController, interactor: UserDetailInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        view.checkFollow(isFollowed: false)
        view.updateFollowButton(isFollowed: false)
        interactor.loadPost()
     }

    func loadUser(userId: String) {
        interactor.loadUser(userId: userId )
    }
    
    func follow(userId: String) {
        interactor.follow(userId: userId)
    }
    
    func unfollow(userId: String) {
        interactor.unfollow(userId: userId)
    }
    
    func updateUserInfo(_ user: User) {
        view.updateUserInfo(user)
        view.checkFollow(isFollowed: user.isFollowed ?? false)
        view.updateFollowButton(isFollowed: user.isFollowed ?? false)
    }
    
    func isFollowedUpdateButton(isFollowed: Bool) {
        view.checkFollow(isFollowed: isFollowed)
        view.updateFollowButton(isFollowed: isFollowed)
    }
    
    private func loadPosts(with post: [Post]) {
        view.loadPosts(post)
    }
}

extension UserDetailPresenter: UserDetailInteractorDelegate {
    func handleOutput(_ output: UserDetailInteractorOutput) {
        switch output {
        case .showUser(let user):
                updateUserInfo(user)
        case .buttonUpdateTitle(let isFollowed):
            isFollowedUpdateButton(isFollowed: isFollowed)
        case .showPosts(let posts):
            loadPosts(with: posts)
        default:
            break
        }
    }
}

