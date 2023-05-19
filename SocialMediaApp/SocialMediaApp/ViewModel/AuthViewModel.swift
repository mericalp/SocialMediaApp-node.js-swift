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
    
    static let shared = AuthViewModel()
    private let defaults = UserDefaults.standard

    init() {
        let token = defaults.object(forKey: "jsonwebtoken")
        
        if token != nil {
            isAuthenticated = true
            if let userId = defaults.object(forKey: "userid") {
                fetchUser(userId: userId as! String)
//                print("user Fetch")
            }
        } else {
            isAuthenticated = false
        }
    }
    
    func login () {
        let defaults = UserDefaults.standard        
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
        let defaults = UserDefaults.standard
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
//        AuthService.requestDomain = "http://localhost:8000/users/\(userId)"
        
        AuthService.fetchUser(id: userId) { result in
            switch result {
            case .success(let data):
                guard let user = try? JSONDecoder().decode(User.self, from: data as! Data) else { return }
                DispatchQueue.main.async {
                    defaults.setValue(user.id, forKey: "userid")
                    self.isAuthenticated = true
                    self.currentUser = user
//                    print(user)
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
            // Kullanıcıyı giriş ekranına yönlendirebilirsin
        }
    }
    

    private func setUserDefaults(token: String, userId: String) {
        defaults.setValue(token, forKey: "jsonwebtoken")
        defaults.setValue(userId, forKey: "userid")
    }
    
}
