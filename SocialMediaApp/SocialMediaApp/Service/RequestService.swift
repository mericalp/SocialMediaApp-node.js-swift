//
//  RequestService.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//

import Foundation

public class RequestService {
    public static var requestDomain = ""
    
    public static func postContent(text: String, user: String, username: String, userId: String, completion: @escaping (_ result: [String:Any]? ) -> Void ) {
        let params = ["text" : text, "userId" : userId, "user": user, "username" : username] as [String : Any]
        let url = URL(string: requestDomain)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch let error {
            print(error)
        }
        
        let token = UserDefaults.standard.string(forKey: "jsonwebtoken")!
        print("Bearer \(token)")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, res, err in
            guard err == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                completion(json)
                }
            }
            catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    static func fetchData (completion: @escaping (_ result: Result<Data?,NetworkError>) -> Void) {
        let url = URL(string: requestDomain)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, err in
            guard err == nil else { return }
            guard let data = data else { return }
            completion(.success(data))
        }
        task.resume()
    }
    
    public static func clapPost(id: String, completion: @escaping (_ result: [String:Any]?) -> Void) {
            let params = ["id" : id] as [String : Any]
            let url = URL(string: requestDomain)!
            let session = URLSession.shared
        
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch let error {
                print(error)
            }

            let token = UserDefaults.standard.string(forKey: "jsonwebtoken")!
            print("Bearer \(token)")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        
            let task = session.dataTask(with: request) { data, res, err in
                guard err == nil else { return }
                guard let data = data else { return }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completion(json)
                    }
                } catch let error {
                    print(error)
                }
            }
            task.resume()
    }
    
    public static func sendNotification(username: String, notSenderId: String, notReceiverId: String, notificationType: String, postText: String, completion: @escaping (_ result: [String:Any]?) -> Void) {
            var params : [String: Any] {
                return postText.isEmpty ? ["username": username, "notSenderId": notSenderId, "notReceiverId": notReceiverId, "notificationType": notificationType] as [String : Any] : ["username": username, "notSenderId": notSenderId, "notReceiverId": notReceiverId, "notificationType": notificationType, "postText": postText] as [String : Any]
            }
            
            let url = URL(string: requestDomain)!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            } catch let error {
                print(error)
            }
        
            let token = UserDefaults.standard.string(forKey: "jsonwebtoken")!
            print("Bearer \(token)")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        
            let task = session.dataTask(with: request) { data, res, err in
                guard err == nil else { return }
                guard let data = data else { return }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        completion(json)
                    }
                } catch let error {
                    print(error)
                }
            }
            task.resume()
    }
    
    
}
