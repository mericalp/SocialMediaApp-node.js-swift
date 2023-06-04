//
//  SettingsRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 2.06.2023.
//

import Foundation

protocol SettingRouterProtocol: AnyObject {
    func logout()
}

class SettingsRouter: SettingRouterProtocol {
    var delegate: SceneDelegate
    var view: SettingsViewController
    
    init(view: SettingsViewController, delegate: SceneDelegate) {
        self.view = view
        self.delegate = delegate
    }
    
    func logout() {
        deleteJWT()
        let welcomeViewController = WelcomeViewController()
        delegate.redirect(to: welcomeViewController)
    }
    
    func deleteJWT() {
        UserDefaults.standard.removeObject(forKey: "jsonwebtoken")
        print(LocalState.jwt)
        print(LocalState.jwt)
    }
    
}
