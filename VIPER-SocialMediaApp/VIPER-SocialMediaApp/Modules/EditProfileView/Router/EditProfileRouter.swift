//
//  EditProfileRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 2.06.2023.
//

import Foundation

protocol EditProfilRouterProtocol: AnyObject {
    func dismiss()
}

class EditProfilRouter: EditProfilRouterProtocol {
    var view: EditProfileViewController
    
    init(view: EditProfileViewController) {
        self.view = view
    }
    
    func dismiss() {
        view.dismiss(animated: true)
    }
}
