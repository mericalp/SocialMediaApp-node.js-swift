//
//  LoginPresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import Foundation

// Presenter Protokolü
protocol LoginPresenterProtocol: AnyObject {
    func loginButtonTapped(email: String, password: String)
    func loginFailure(error: Error)
}

class LoginPresenter: LoginPresenterProtocol {
    let view: LoginViewController
    let interactor: LoginInteractor
    let router: LoginRouter
    
    init(view: LoginViewController, interactor: LoginInteractor, router: LoginRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func loginButtonTapped(email: String, password: String) {
        interactor.performLogin(email: email, password: password)
    }
    
    func setFailed(failed: Bool) {
        view.displayError(error: failed as! Error)
    }
    
    func loginFailure(error: Error) {
        view.displayError(error: error)
    }
}

extension LoginPresenter: LoginInteractorDelegate {
    func handleOutput(_ output: LoginInteractorOutput) {
        switch output {
        case .showHome(let response):
            router.showHome(response: response)
        case .loginFailure(let err):
            loginFailure(error: err)
        }
    }
}

