//
//  PostPresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 31.05.2023.
//

import Foundation
import UIKit

protocol PostCreatePresenterProtocol {
    func postCreateButtonTapped(text: String, image: UIImage?,user: User)
    func fetchCurrentUser(_ user: User)
    func viewDidLoad()
}

class PostCreatePresenter: PostCreatePresenterProtocol {
    let view: PostViewController
    let interactor: PostCreateInteractor
    
     init( view: PostViewController, interactor: PostCreateInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        interactor.fetchCurrentUser()
    }
    
    func postCreateButtonTapped(text: String, image: UIImage?, user: User) {
        interactor.fetchCurrentUser()
        interactor.postcontent(text: text, image: image ?? UIImage(), user: user)
    }

    func fetchCurrentUser(_ user: User) {
        view.user = user
        print("postcreate view.user")
        print(view.user)
        print(view.user)
    }
}

extension PostCreatePresenter: PostCreateInteractorDelegate {
    func handleOutput(_ output: PostCreateInteractorOutput) {
        switch output {
        case .getCurrentUser(let user):
            fetchCurrentUser(user)
        }
    }
}
