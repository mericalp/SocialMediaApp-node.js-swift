//
//  ProfileRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import UIKit

protocol ProfileRouterProtocol: class {
    func showEditProfile(with user: User)
}

class ProfileRouter: ProfileRouterProtocol {
    var viewController: ProfileViewController?
    
    init(viewController: ProfileViewController) {
         self.viewController = viewController
     }
    
    func showEditProfile(with user: User) {
        let editProfileVC = EditProfileViewController(user: user)
        viewController?.present(editProfileVC, animated: true)
    }
    
}
