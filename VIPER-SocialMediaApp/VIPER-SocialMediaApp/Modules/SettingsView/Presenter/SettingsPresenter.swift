//
//  SettingsPresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 2.06.2023.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    func logout()
}

class SettingsPresenter: SettingsPresenterProtocol {
    let view: SettingsViewController
    private let interactor: SettingsInteractorProtocol
    let router: SettingsRouter
    
    init(view: SettingsViewController, interactor: SettingsInteractorProtocol, router: SettingsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func logout() {
        interactor.logout()
    }
    
}

extension SettingsPresenter: SettingsInteractorDelegate {
    func handleOutput(_ output: SettingsInteractorOutput) {
        switch output {
        case .logout:
            router.logout()
        }
    }
}
