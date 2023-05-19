//
//  Request.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 19.05.2023.
//

import Foundation

extension URLRequest {
    mutating func addAuthHeaders() {
        let token = UserDefaults.standard.string(forKey: "jsonwebtoken") ?? ""
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}

