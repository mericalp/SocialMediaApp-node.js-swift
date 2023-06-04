//
//  ProfilePresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 25.05.2023.
//

import Foundation
import Kingfisher


enum ProfilePresenterOutput {
    case setLoading(Bool)
}

protocol ProfilePresenterProtocol: class {
    func viewDidLoad()
    func editProfileButtonTapped(_ user: User)
}

class ProfilePresenter: ProfilePresenterProtocol {
    let view: ProfileViewProtocol
    private let interactor: ProfileInteractorProtocol2
    let router: ProfileRouter
    
    init (view: ProfileViewProtocol, interactor: ProfileInteractorProtocol2, router: ProfileRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view.showLoading(true)
        interactor.fetchUsers()
        interactor.loadPost()
     }

    private func updateUserLabel(with user: User) {
        view.updateUserLabel(user)
    }
    
    private func loadPosts(with post: [Post]) {
        view.loadPosts(post)
    }
    
    func editProfileButtonTapped(_ user: User) {
           router.showEditProfile(with: user)
    }
    
}

extension ProfilePresenter: ProfileInteractorDelegate {
    func handleOutput(_ output: ProfileInteractorOutput) {
        switch output {
        case .showUser(let user):
            updateUserLabel(with: user)
        case .showPosts(let posts):
            loadPosts(with: posts)
        default:
            break
        }
    }
}
