//
//  LoginInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import Foundation

enum LoginError: Error {
    case nilLoginData
    case invalidFormat
    case decodeError
    
    var description: String {
        switch self {
        case .nilLoginData:
            return "Login Data is nil."
        case .invalidFormat:
            return "Login Invalid data format."
        case .decodeError:
            return "Login Decode error"
        }
    }
}

enum LoginInteractorOutput {
    case showHome(ApiResponse)
    case loginFailure(Error)
}

protocol LoginInteractorProtocol: AnyObject {
    func performLogin(email: String, password: String)
}

protocol LoginInteractorDelegate: AnyObject  {
    func handleOutput(_ output: LoginInteractorOutput)
}

class LoginInteractor: LoginInteractorProtocol {
    weak var delegate: LoginInteractorDelegate?
    private let service: NetworkManager
    
    init(service: NetworkManager) {
        self.service = service
    }
    
    func performLogin(email: String, password: String) {
        NetworkManager.login(email: email, password: password) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    print(LoginError.nilLoginData)
                    return
                }
                do {
                    let user = try JSONDecoder().decode(ApiResponse.self, from: data)
                    DispatchQueue.main.async {
                        LocalState.jwt = user.token
                        LocalState.userId = user.user.id
                        self.delegate?.handleOutput(.showHome(user))
                    }
                } catch {
                    print(LoginError.decodeError)
                }
            case .failure(let error):
                self.delegate?.handleOutput(.loginFailure(error))
                print(error.localizedDescription)
            }
        }
    }
    
}
