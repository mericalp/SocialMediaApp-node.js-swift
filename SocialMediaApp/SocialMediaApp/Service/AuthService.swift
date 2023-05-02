//
//  AuthService.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import Foundation
import SwiftUI


enum AuthError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
}

public class AuthService {
    public static var requestDomain = ""
    
    static func login(email: String, password: String, username: String, name: String, completion: @escaping ( _ result: Result<Data?,AuthError>) -> Void ) {
        let urlString = URL(string: "http://localhost:3000/users/login")!
        makeRequest(urlString: urlString, reqBody: ["email": email, "password": password]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.failure(.invalidCredentials))
                print(err.localizedDescription)
            }
        }
    }
    
    static func register(email: String, password: String, username: String, name: String, completion: @escaping(_ result: Result<Data?, AuthError>) -> Void) {
        let urlString = URL(string: "http://localhost:3000/users")!
        makeRequest(urlString: urlString, reqBody: ["email": email, "name": name, "username": username, "password": password]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(.invalidUrl):
                completion(.failure(.custom(errorMessage: "invalid URL error")))
            case .failure(.decodingError):
                completion(.failure(.custom(errorMessage: "Decoding error")))
            case.failure(.noData):
                completion(.failure(.custom(errorMessage: "no Data error")))
            }
        }
    }
    
    
    static func makeRequest(urlString: URL, reqBody: [String: Any], completion: @escaping (_ result:Result<Data?,NetworkError>) -> Void ) {
        let session = URLSession.shared
        var request = URLRequest(url: urlString)
        request.httpMethod = "POST"
        let boundry = UUID().uuidString
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: .prettyPrinted)
        } catch let error {
            print(error)
        }
        
        let token = UserDefaults.standard.string(forKey: "jsonwebtoken")
        print("Bearer \(token ?? "not token" )")
        request.addValue("Bearer \(token ?? "not token" )", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, err in
            guard err == nil else { return }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
            
            do {
                if let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] { }
            } catch let error {
                completion(.failure(.decodingError))
                print(error)
            }
        }
        task.resume()
    }
    
    
    static func makeRequestWithAuth(urlString: URL, reqBody: [String: Any], completion: @escaping (_ result: Result<Data?, NetworkError>) -> Void ) {
        let session = URLSession.shared
        var request = URLRequest(url: urlString)
        request.httpMethod = "PATCH"
        let boundary = UUID().uuidString
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: .prettyPrinted)
        } catch let error {
            print(error)
        }
        
        let token = UserDefaults.standard.string(forKey: "jsonwebtoken")
        print("Bearer \(token ?? "not token" )")
        request.addValue("Bearer \(token ?? "not token" )", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, err in
            guard err == nil else { return }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
            
            do {
                if let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] { }
            } catch let error {
                completion(.failure(.decodingError))
                print(error)
            }
        }
        task.resume()
    }
    
    static func fetchUser(id: String, completion: @escaping (_ result: Result<Data?, AuthError>) -> Void) {
        let urlString = URL(string: "http://localhost:3000/users/\(id)")!
        let urlRequest = URLRequest(url: urlString)
        let url = URL(string: requestDomain)!
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, err in
            guard err == nil else { return }
            guard let data = data else {
                completion(.failure(.invalidCredentials))
                return
            }
            completion(.success(data))
            
            do {
                if let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] { }
            } catch let error {
                completion(.failure(.invalidCredentials))
                print(error)
            }
        }
        task.resume()
    }
    
    static func fetchUsers(completion: @escaping (_ result: Result<Data?, AuthError>) -> Void) {
        let urlString = URL(string: "http://localhost:3000/users")!
        let urlRequest = URLRequest(url: urlString)
        let url = URL(string: requestDomain)!
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, res, err in
            guard err == nil else { return }
            guard let data = data else {
                completion(.failure(.invalidCredentials))
                return
            }
            completion(.success(data))
            
            do {
                if let _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                }
            }
            catch let error {
                completion(.failure(.invalidCredentials))
                print(error)
            }
        }
        task.resume()
    }
    
}
