//
//  RegisterRouter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import Foundation
import UIKit

// MARK: - Router
protocol RegisterRouterProtocol {
    func showWelcomeView()
}

class RegisterRouter: RegisterRouterProtocol {
    var view: RegisterViewController
    
    init(view: RegisterViewController) {
        self.view = view
    }
    
    func showWelcomeView(){
        view.dismiss(animated: true)
    }
}

