//
//  NotificationPresenter.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 29.05.2023.
//

import Foundation

protocol NotificationPresenterProtocol {
    func updateNotification(with noti: [Notification])
    func viewDidLoad()
    func selectNotification(at index: Int)
}

class NotificationPresenter: NotificationPresenterProtocol {
    let viewController: NotificationViewControllerProtocol?
    let interactor: NotificationInteractor
    let router: NotificationRouter
    
    init(viewController: NotificationViewControllerProtocol, interactor: NotificationInteractor, router: NotificationRouter) {
        self.viewController = viewController
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchPosts()
    }

    func updateNotification(with noti: [Notification]) {
        viewController?.getNotification(noti)
    }
    
    func selectNotification(at index: Int) {
        interactor.selectNotification(at: index)
    }
    
}

extension NotificationPresenter: NotificationInteractorDelegate {
    func handleOutput(_ output: NotificationInteractorOutput) {
        switch output {
        case .showNotification(let array):
            updateNotification(with: array)
        case .showUserDetail(let receiverId):
            router.showProfile(with: receiverId)
        }
    }
}
