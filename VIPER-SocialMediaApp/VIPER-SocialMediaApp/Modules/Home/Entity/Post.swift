//
//  Post.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 21.05.2023.
//

import Foundation

// Entity
struct Post: Identifiable, Decodable {
    let _id: String
    let text: String
    let userId: String
    let username: String
    let user: String
    var id: String {
        return _id
    }
    let image: String?
    var likes: [String]
    var didClap: Bool? = false
}
