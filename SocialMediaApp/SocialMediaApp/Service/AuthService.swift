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
    case custom(errorMessage: String)
}

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum Path: String {
    case users = "users"
    case post = "posts"
    case login = "users/login"
    case avatar = "users/me/avatar"
    case uploadPostImage = "uploadPostImage/"
    case notification = "notification"
    case like = "like"
    case unlike = "unlike"
    case follow = "follow"
    case unfollow = "unfollow"
    
    static let baseUrl: String = "http://localhost:8000/"
    
    func url() -> URL? {
            return URL(string: Path.baseUrl + rawValue)
    }
}

public class AuthService {
    public static var requestDomain = ""
    
       static func login(email: String, password: String, completion: @escaping (Result<Data?, AuthError>) -> Void) {
           guard let url = URL(string: Path.baseUrl + Path.login.rawValue) else {
               completion(.failure(.invalidCredentials))
               return
           }
           print("\(url)")
           let requestBody = ["email": email, "password": password]
           makeRequest(url: .login, method: .post, body: requestBody, completion: completion)
       }
       
       static func register(email: String, password: String, username: String, name: String, completion: @escaping (Result<Data?, AuthError>) -> Void) {
           guard let url = URL(string: "http://localhost:8000/users") else {
               completion(.failure(.invalidCredentials))
               return
           }
           
           let requestBody = ["email": email, "name": name, "username": username, "password": password]
           makeRequest(url: .users, method: .post, body: requestBody, completion: completion)
       }
       
    
    static func makeRequest(url: Path, method: Method, body: [String: Any], completion: @escaping (Result<Data?, AuthError>) -> Void) {
        var request = URLRequest(url: url.url()!)
        request.httpMethod = method.rawValue
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            completion(.failure(.custom(errorMessage: "JSON serialization error")))
            return
        }
        request.addAuthHeaders()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.invalidCredentials))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    
    static func makeRequestWithAuth(url: URL, method: Method, reqBody: [String: Any], completion: @escaping (_ result: Result<Data?, NetworkError>) -> Void ) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let boundary = UUID().uuidString
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: reqBody, options: .prettyPrinted)
        } catch {
            completion(.failure(.custom(errorMessage: "JSON serialization error")))
            return
        }
        request.addAuthHeaders()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.invalidUrl))
                return
            }
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
        let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(id)")!
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = Method.get.rawValue
        request.addAuthHeaders()
        
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
        let urlString = URL(string: "\(Path.baseUrl)\(Path.users)")!
        let session = URLSession.shared
        var request = URLRequest(url: urlString)
        request.httpMethod = Method.get.rawValue
        request.addAuthHeaders()
        
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
