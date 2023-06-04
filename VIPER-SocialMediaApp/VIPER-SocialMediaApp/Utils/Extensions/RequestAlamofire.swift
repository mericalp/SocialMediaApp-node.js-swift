//
//  Request.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 25.05.2023.
//

import Foundation
import Alamofire

extension URLRequest {
    mutating func addAuthHeaders() {
        let token = UserDefaults.standard.string(forKey: "jsonwebtoken") ?? ""
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}

extension HTTPHeaders {
    static func customHeaders() -> HTTPHeaders {
          let token = UserDefaults.standard.string(forKey: "jsonwebtoken") ?? ""
          let headers: HTTPHeaders = [
              "Authorization": "Bearer \(token)",
              "Content-Type": "application/json",
              "Accept": "application/json"
          ]
          return headers
      }
}

