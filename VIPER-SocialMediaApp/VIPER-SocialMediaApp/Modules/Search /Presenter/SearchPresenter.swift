//
//  SearchPresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 27.05.2023.
//

import Foundation

enum SearchPresenterOutput {
//    case updateTitle(String)
    case setLoading(Bool)
    case showUser([User])
}

protocol SearchPresenterProtocol: AnyObject {
    func viewDidLoad()
    func selectUser(at index: Int)
}

class SearchPresenter: SearchPresenterProtocol {
    let view: SearchViewProtocol
    var interactor: SearchInteractorProtocol2
    let router: SearchRouter

    init(view: SearchViewProtocol, interactor: SearchInteractorProtocol2, router: SearchRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view.showLoading(true)
        interactor.load()
    }

    private func updateUserLabel(with user: [User]) {
        view.getUsers(user)
    }
    
    func selectUser(at index: Int) {
        interactor.selectUser(at: index)
    }
    
}

extension SearchPresenter: SearchInteractorDelegate {
    func handleOutput(_ output: SearchInteractorOutput) {
        switch output {
        case .showUsers(let user):
            updateUserLabel(with: user)
        case .showUserDetail(let user):
            router.showProfile(with: user)
        default:
            break
        }
    }
}
