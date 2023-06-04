//
//  SearchRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import UIKit


protocol SearchRouterProtocol: class {
    func showProfile(with user: User)
}

class SearchRouter: SearchRouterProtocol {
    var viewController: SearchViewController?
    
    init(viewController: SearchViewController) {
         self.viewController = viewController
     }
    
    func showProfile(with user: User) {
        let editProfileVC = UserDetailViewController(user: user, user_: "")
        viewController?.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
}



