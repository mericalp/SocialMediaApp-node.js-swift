//
//  SearchInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 27.05.2023.
//

import Foundation
import Alamofire

protocol SearchInteractorProtocol2: class {
    func load()
    func selectUser(at index: Int)
}

enum SearchInteractorOutput {
    case setLoading(Bool)
    case showUsers([User])
    case showUserDetail(User)
}

protocol SearchInteractorDelegate: class {
    func handleOutput(_ output: SearchInteractorOutput)
}

class SearchInteractor: SearchInteractorProtocol2 {
    weak var delegate: SearchInteractorDelegate?
    private let service: NetworkManager
    private var users: [User] = []
    
    init(service: NetworkManager) {
        self.service = service
    }
    
    func load() {
        delegate?.handleOutput(.setLoading(true))
        NetworkManager.fetchUsers { result in
            switch result {
            case .success(let data):
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    self.users = users
                    self.delegate?.handleOutput(.showUsers(users))
                } catch { }
            case .failure(let error):
                print("error")
            }
        }
    }
    
    func selectUser(at index: Int) {
        let user = users[index]
        delegate?.handleOutput(.showUserDetail(user))
    }
    
}


