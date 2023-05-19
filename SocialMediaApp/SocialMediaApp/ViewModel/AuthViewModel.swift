//
//  AuthViewModel.swift
//  twitter-clone (iOS)
//
//  Created by cem on 8/23/21.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?

    private let defaults = UserDefaults.standard
    static let shared = AuthViewModel()
    
    init() {
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "jsonwebtoken")

        if token != nil {
            isAuthenticated = true
            if let userId = defaults.object(forKey: "userid") {
                fetchUser(userId: userId as! String)
            }
        } else {
            isAuthenticated = false
        }
    }
    
    func login () {
        AuthService.login(email: email, password: password) { result in
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(ApiResponse.self, from: data as! Data) else { return }
                DispatchQueue.main.async {
                    self.setUserDefaults(token: user.token, userId: user.user.id)
                    self.isAuthenticated = true
                    self.currentUser = user.user
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func register() {
        AuthService.register(email: email, password: password, username: username, name: name) { result in
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(ApiResponse.self, from: data as! Data) else { return }
                DispatchQueue.main.async {
                    self.setUserDefaults(token: user.token, userId: user.user.id)
                    self.isAuthenticated = true
                    self.currentUser = user.user
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUser(userId: String) {
        let defaults = UserDefaults.standard
        AuthService.fetchUser(id: userId) { result in
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data as! Data) else { return }
                DispatchQueue.main.async {
                    defaults.setValue(user.id, forKey: "userid")
                    self.isAuthenticated = true
                    self.currentUser = user
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "jsonwebtoken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }

    private func setUserDefaults(token: String?, userId: String?) {
        defaults.setValue(token, forKey: "jsonwebtoken")
        defaults.setValue(userId, forKey: "userid")
    }
}
