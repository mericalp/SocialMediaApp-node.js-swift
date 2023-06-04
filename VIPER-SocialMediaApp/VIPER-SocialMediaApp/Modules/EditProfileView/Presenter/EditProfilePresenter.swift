//
//  EditProfilePresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import UIKit

protocol EditProfilePresenterProtocol: class {
    func save(name: String, location: String, image: UIImage)
    func withoutImage(name: String, location: String)
}

class EditProfilePresenter: EditProfilePresenterProtocol {
    let view: EditProfileViewController
    let interactor: EditProfileInteractor
    let router: EditProfilRouter
    
    init (view: EditProfileViewController, interactor: EditProfileInteractor, router: EditProfilRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func save(name: String, location: String, image: UIImage) {
        interactor.uploadProfileImage(text: "text", image: image)
        interactor.update(name: name, location: location)
    }
    
    func withoutImage(name: String, location: String) {
        interactor.update(name: name, location: location)
    }
    
}

extension EditProfilePresenter: EditProfilInteractorDelegate {
    func handleOutput(_ output: EditProfilInteractorOutput) {
        switch output {
        case .dismiss:
            router.dismiss()
        }
    }
}
