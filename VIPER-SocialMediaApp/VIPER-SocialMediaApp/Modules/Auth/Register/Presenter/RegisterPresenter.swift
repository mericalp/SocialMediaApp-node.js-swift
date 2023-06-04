//
//  RegisterPresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import Foundation

// MARK: - Presenter
protocol RegisterPresenterProtocol {
    func registerButtonTapped(email: String?, password: String?, username: String?, name: String?)
}

class RegisterPresenter: RegisterPresenterProtocol {
    let view: RegisterViewController
    let interactor: RegisterInteractor
    let router: RegisterRouter
    
    init(view: RegisterViewController, interactor: RegisterInteractor, router: RegisterRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    func registerButtonTapped(email: String?, password: String?, username: String?, name: String?) {
        guard let email = email, let password = password, let username = username, let name = name else {
            return
        }

        interactor.register(email: email, password: password, username: username, name: name)
    }
    
}

extension RegisterPresenter: RegisterInteractorDelegate {
    func handleOutput(_ output: RegisterInteractorOutput) {
        switch output {
        case .showWelcome:
            router.showWelcomeView()
        case .registerFailure(_):
            break
        }
    }
}
