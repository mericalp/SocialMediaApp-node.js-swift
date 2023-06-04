//
//  NotificaitonInteractor.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 29.05.2023.
//

import Foundation

protocol NotificationInteractorProtocol {
    func fetchPosts()
    func selectNotification(at index: Int)
}

enum NotificationInteractorOutput {
    case showNotification([Notification])
    case showUserDetail(String)
}

protocol NotificationInteractorDelegate: AnyObject {
    func handleOutput(_ output: NotificationInteractorOutput)
}

class NotificationInteractor: NotificationInteractorProtocol {
    weak var delegate: NotificationInteractorDelegate?
    let service: NetworkManager
    private var notifications: [Notification] = []
    
    init(service: NetworkManager) {
        self.service = service
    }
    
    func fetchPosts() {
        service.fetchNotification { result in
            switch result {
            case .success(let data):
                do {
                    let notifications = try JSONDecoder().decode([Notification].self, from: data)
                    self.delegate?.handleOutput(.showNotification(notifications))
                    self.notifications = notifications
                } catch { }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func selectNotification(at index: Int) {
        let noti = notifications[index]
        delegate?.handleOutput(.showUserDetail(noti.notSenderId))
    }
    
}
