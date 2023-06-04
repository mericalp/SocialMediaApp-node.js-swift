//
//  Notification.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 29.05.2023.
//

import Foundation

struct Notification: Decodable, Identifiable {
    var _id: String
    var id: String {
        return _id
    }
    var username: String
    var notSenderId: String
    var notReceiverId: String
    var postText: String?
    var notificationType: NotificationType
    
}

enum NotificationType: String, Decodable {
    case clap = "clap"
    case follow = "follow"
    
    var notificationMessage: String {
        switch self {
        case .clap: return "clap your post"
        case .follow: return "followed you"
        }
    }
}
