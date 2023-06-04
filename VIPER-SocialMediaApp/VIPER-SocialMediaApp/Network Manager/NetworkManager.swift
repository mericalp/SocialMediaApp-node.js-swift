//
//  nn.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 3.06.2023.
//

import Foundation
//
//  NetworkManager.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import Foundation
import Alamofire

enum AuthError: Error {
    case invalidResponseFormat
    case custom(errorMessage: String)
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

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}


class NetworkManager {

    // TODO: PostContent -
    public static func postContent(text: String, user: String, username: String, userId: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        let params = ["text": text, "userId": userId, "user": user, "username": username]
        guard let url = URL(string: "\(Path.baseUrl)\(Path.post.rawValue)") else { return }
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,headers: HTTPHeaders.customHeaders()).response { response in
            switch response.result {
                case .success(let data):
                    if let jsonData = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                                 completion(json)
                              }
                        } catch {
                            print("Error during JSON serialization: \(error)")
                        }
                    } else {
                    }
                case .failure(let error):
                    print("Error: \(error)")
            }
        }
    }
    
    // TODO: Register -
    static func register(email: String, password: String, username: String, name: String, completion: @escaping (Result<Data?, AuthError>) -> Void) {
        let parameters: [String: Any] = ["email": email, "password": password, "username": username, "name": name]
        guard let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)") else { return }
        
        makeRequest(url: url, method: .post, body: parameters, completion: completion)

    }
    
    // TODO: Login -
    static func login(email: String, password: String, completion: @escaping (Result<Data?, AuthError>) -> Void) {
        guard let url = URL(string: Path.baseUrl + Path.login.rawValue) else {
            completion(.failure(.invalidResponseFormat))
            return
        }
        let requestBody = ["email": email, "password": password]
        makeRequest(url: url, method: .post, body: requestBody, completion: completion)
    }
    
    // TODO: MakeRequest (for Login, Register ... )-
    private static func makeRequest(url: URL, method: HTTPMethod, body: [String: Any], completion: @escaping (Result<Data?, AuthError>) -> Void) {
        AF.request(url, method: method, parameters: body, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                print(data)
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        }
    }
    
    // TODO: FetchUser -
    static func fetchUser(id: String, completion: @escaping (_ result: Result<Data?, AuthError>) -> Void) {
        let url = "\(Path.baseUrl)\(Path.users.rawValue)/\(id)"
        AF.request(url, method: .get, headers: HTTPHeaders.customHeaders()).response { response in
               switch response.result {
               case .success(let data):
                   guard let data = data else {
                       completion(.failure(.invalidResponseFormat))
                       return
                   }
                   completion(.success(data))
                   do {
                       if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] { }
                   } catch let error {
                       completion(.failure(.invalidResponseFormat))
                       print(error)
                   }
               case .failure(let error):
                   completion(.failure(.invalidResponseFormat))
               }
           }
       }
    
    // TODO: Logout -
    func logout() {
        LocalState.userId = nil
        LocalState.jwt = nil
    }
    
    // TODO: ClapPost -
    public static func clapPost(id: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        let params = ["id": id]
        guard let url = URL(string: "\(Path.baseUrl)\(Path.post.rawValue)/\(id)/\(Path.like.rawValue)") else { return }
 
        sendAFRequest(request: url, completion: completion)
    }
    
    // TODO: unClapPost -
    public static func unclapPost(id: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        let params = ["id": id]
        guard let url = URL(string: "\(Path.baseUrl)\(Path.post.rawValue)/\(id)/\(Path.unlike.rawValue)") else { return }
 
        sendAFRequest(request: url, completion: completion)
    }
    
    // TODO: AFRequest (for clapPost, unClapPost ...) -
    private static func sendAFRequest(request: URL, completion: @escaping (_ result: [String: Any]?) -> Void) {
        AF.request(request,method: .put, headers: HTTPHeaders.customHeaders()).responseData { response in
            switch response.result {
            case .success(let data):
                if !data.isEmpty {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            completion(json)
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // TODO: FetchUsers -
    static func fetchUsers(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)") else { return }
           AF.request(url).response { response in
               switch response.result {
               case .success(let data):
                   completion(.success(data!))
          
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    // TODO: updateProfile -
    static func updateProfile(url: URL, method: HTTPMethod, reqBody: [String: Any], completion: @escaping (_ result: Result<Data?, AuthError>) -> Void) {
   
        AF.request(url, method: method, parameters: reqBody, encoding: JSONEncoding.default, headers: HTTPHeaders.customHeaders())
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    do {
                        if let jsonData = data, let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                        }
                    } catch {
                        completion(.failure(.invalidResponseFormat))
                        print(error)
                    }
                case .failure(let error):
                    completion(.failure(.custom(errorMessage: error.localizedDescription)))
                }
            }
    }
    
    // TODO: FollowingProcess -
    func followingProcess(url: URL, id: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        let params = ["id": id]

        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default,headers: HTTPHeaders.customHeaders())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(json)
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
    }
    
    func fetchPosts(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(Path.baseUrl)\(Path.post.rawValue)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
                print(data)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public static func sendNotification(username: String, notSenderId: String, notReceiverId: String, notificationType: String, postText: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        var params: [String: Any] = [
            "username": username,
            "notSenderId": notSenderId,
            "notReceiverId": notReceiverId,
            "notificationType": notificationType
        ]
        
        if !postText.isEmpty {
            params["postText"] = postText
        }
        guard let url = URL(string: "\(Path.baseUrl)\(Path.notification.rawValue)") else { return }
        makeRequest(method: .post, url: url, parameters: params) { result in
                switch result {
                case .success(let json):
                    completion(json)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    //TODO: makeRequest will be Deleted ....
    static func makeRequest(method: HTTPMethod, url: URL, parameters: [String: Any]?, completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default,headers: HTTPHeaders.customHeaders()).responseData { response in
               switch response.result {
               case .success(let value):
                   if let json = value as? [String: Any] {
                       completion(.success(json))
                   } else {
                      print("asdasd")
                   }
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    //TODO: Fetch Notification
    func fetchNotification(completion: @escaping (Result<Data, Error>) -> Void) {
        let userId = LocalState.userId as! String
        guard let url = URL(string: "\(Path.baseUrl)\(Path.notification.rawValue)/\(userId)") else { return }
        AF.request(url,headers: HTTPHeaders.customHeaders()).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
 
 
