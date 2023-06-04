//
//  RegisterInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import Foundation

enum RegisterError: Error {
    case nilLoginData
    case invalidFormat
    case decodeError
    
    var description: String {
        switch self {
        case .nilLoginData:
            return "Register Data is nil."
        case .invalidFormat:
            return "Register Invalid data format."
        case .decodeError:
            return "Register Decode error"
        }
    }
}

enum RegisterInteractorOutput {
    case showWelcome
    case registerFailure(Error)
}

protocol RegisterInteractorProtocol: AnyObject {
    func register(email: String, password: String, username: String, name: String)
}

protocol RegisterInteractorDelegate: AnyObject  {
    func handleOutput(_ output: RegisterInteractorOutput)
}

class RegisterInteractor: RegisterInteractorProtocol {
    weak var delegate: RegisterInteractorDelegate?
    private let service: NetworkManager
    
    init(service: NetworkManager) {
        self.service = service
    }

    func register(email: String, password: String, username: String, name: String) {
        NetworkManager.register(email: email, password: password, username: username, name: name) { [weak self] result in
            self?.delegate?.handleOutput(.showWelcome)
        }
    }
}
