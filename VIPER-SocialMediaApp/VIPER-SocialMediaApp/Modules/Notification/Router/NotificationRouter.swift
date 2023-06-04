//
//  NotificationRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 2.06.2023.
//

import Foundation

protocol NotificationRouterProtocol: AnyObject {
    func showProfile(with user: String)
}

class NotificationRouter: NotificationRouterProtocol {
    var view: NotificationViewController?
    
    init(view: NotificationViewController) {
        self.view = view
    }
    func showProfile(with user: String) {
        let userDetailVC = UserDetailViewController(user: nil, user_: user)
        view?.navigationController?.pushViewController(userDetailVC, animated: true)
    }
    
}
