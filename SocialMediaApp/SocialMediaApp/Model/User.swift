//
//  User.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//


import Foundation
import SwiftUI
import Kingfisher

struct ApiResponse: Decodable {
    var user: User
    var token: String
}

struct User: Decodable, Identifiable {
    var _id: String
    var name: String
    let username: String
    let email: String
    var id: String {
        return _id
    }
    var location: String?
    var bio: String?
    var website: String?
    var avatarExists: Bool?
    var followers: [String]
    var followings: [String]
    var isCurrentUser: Bool? = false
    var isFollowed: Bool? = false
}



class ImageLoader: ObservableObject {
    @Published var image: KFImage?
    
    func loadImage(from url: URL) {
        self.image = KFImage(url)
    }
}
