//
//  RequestService.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//

import Foundation

public class RequestService {
    public static var requestDomain = ""
    
    static func makeRequest(method: Method, url: URL, body: [String: Any]?, completion: @escaping (_ result: Result<[String: Any]?, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                completion(.failure(.custom(errorMessage: "JSON serialization error")))
                return
            }
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
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    completion(.success(json))
                }
            } catch {
                completion(.failure(.custom(errorMessage: "JSON deserialization error")))
            }
        }
        task.resume()
    }
    
    public static func postContent(text: String, user: String, username: String, userId: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        let params = ["text": text, "userId": userId, "user": user, "username": username]
        guard let url = URL(string: requestDomain) else { return }
        
        makeRequest(method: .post, url: url, body: params) { result in
            switch result {
            case .success(let json):
                completion(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func fetchData (completion: @escaping (_ result: Result<Data?,NetworkError>) -> Void) {
        let url = URL(string: requestDomain)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = Method.get.rawValue
        request.addAuthHeaders()
        
        let task = session.dataTask(with: request) { data, response, err in
            guard err == nil else { return }
            guard let data = data else { return }
            completion(.success(data))
        }
        task.resume()
    }
    
    public static func clapPost(id: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        let params = ["id": id]
        guard let url = URL(string: requestDomain) else { return }
        
        makeRequest(method: .put, url: url, body: params) { result in
            switch result {
            case .success(let json):
                completion(json)
            case .failure(let error):
                print(error)
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
        
        guard let url = URL(string: requestDomain) else { return }
        
        makeRequest(method: .post, url: url, body: params) { result in
            switch result {
            case .success(let json):
                completion(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public static func followingProcess(id: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        let params = ["id": id]
        guard let url = URL(string: requestDomain) else { return }
        
        makeRequest(method: .put, url: url, body: params) { result in
            switch result {
            case .success(let json):
                completion(json)
            case .failure(let error):
                print(error)
            }
        }
    }
}

