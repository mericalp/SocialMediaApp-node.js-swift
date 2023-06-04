//
//  LoginRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import Foundation

// Router Protokolü
protocol LoginRouterProtocol: AnyObject {
    func showHome(response: ApiResponse)
}

class LoginRouter: LoginRouterProtocol {
    var view: LoginViewController
    var delegate: SceneDelegate
    
    init(view: LoginViewController, delegate: SceneDelegate) {
        self.view = view
        self.delegate = delegate
    }
    
    func showHome(response: ApiResponse) {
        print("delegate")
        print(delegate)
        let mainTabBarController = MainTabBarViewController()
        delegate.redirect(to: mainTabBarController)
    }
    
}
