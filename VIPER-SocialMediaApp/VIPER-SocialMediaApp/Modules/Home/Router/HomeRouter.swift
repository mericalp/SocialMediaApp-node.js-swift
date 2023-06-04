//
//  HomeRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import Foundation

protocol HomeRouterProtocol: class {
    func showProfile(with user: String)
}

class HomeRouter: HomeRouterProtocol {
    var viewController: HomeViewController?
    
    init(viewController: HomeViewController) {
        self.viewController = viewController
    }
    
    func showProfile(with user: String) {
        let userDetailVC = UserDetailViewController(user: nil, user_: user)
        viewController?.navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
