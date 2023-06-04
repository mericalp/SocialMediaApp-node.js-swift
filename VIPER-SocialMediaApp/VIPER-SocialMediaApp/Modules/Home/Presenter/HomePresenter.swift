//
//  Presenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 21.05.2023.
//

import Foundation

protocol HomePresenterProtocol {
    func clapPost(post: Post)
    func unclapPost(post: Post)
    func checkIfUserClapPost(post: [Post])
    func selectPost(at index: Int)
    func viewDidLoad()
}

class HomePresenter: HomePresenterProtocol {
    let view: HomeViewControllerProtocol
    let interactor: HomeInteractor
    let router: HomeRouter
    
    init(view: HomeViewControllerProtocol, interactor: HomeInteractor, router: HomeRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view.showLoading(true)
        interactor.loadPost()
    }
    
    private func updatePosts(with post: [Post]) {
        view.getPosts(post)
    }
    
    func selectPost(at index: Int) {
        interactor.selectUser(at: index)
    }

    func clapPost(post: Post) {
        let currentUser = (LocalState.userId as? String)!
        if post.likes.contains(currentUser) {
            print("Already liked")
            interactor.unclapPost(post: post)
            return
        } else {
            interactor.clapPost(post: post)
        }
    }
 
    func unclapPost(post: Post) {
        interactor.unclapPost(post: post)
    }
    
    func checkIfUserClapPost(post: [Post]) {
        interactor.checkIfUserClapPost(posts: post)
    }
    
}

extension HomePresenter: HomeInteractorDelegate {
    func handleOutput(_ output: HomeInteractorOutput) {
        switch output {
        case .showPosts(let array):
            updatePosts(with: array)
        case .showUserDetail(let user):
            router.showProfile(with: user)
        default:
            break
        }
    }
}
