//
//  SettingsInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 2.06.2023.
//

import Foundation

protocol SettingsInteractorProtocol: AnyObject {
    func logout()
}

enum SettingsInteractorOutput {
    case logout
}

protocol SettingsInteractorDelegate: AnyObject {
    func handleOutput(_ output: SettingsInteractorOutput)
}

class SettingsInteractor: SettingsInteractorProtocol {
    weak var delegate: SettingsInteractorDelegate?
    private let service:  NetworkManager
    
    init(service: NetworkManager) {
        self.service = service
    }
    
    func logout() {
        NetworkManager().logout()
        self.delegate?.handleOutput(.logout)
    }
    
}
