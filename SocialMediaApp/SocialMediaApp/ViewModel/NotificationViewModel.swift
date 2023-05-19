//
//  NotificationViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import Foundation

class NotificationViewModel: ObservableObject {
    let user: User
    @Published var notiCount: Int = 0
    @Published var notifications = [Notification](){
        didSet {
            // Veriler güncellendiğinde yapılacak işlemler
            // Örneğin, yeniden yükleme veya ekranda güncelleme
        }
    }
    
    init(user: User) {
        self.user = user
        fetchNotifications()
    }
    
    func fetchNotifications () {
        RequestService.requestDomain = "\(Path.baseUrl)\(Path.notification.rawValue)/\(self.user.id)"
        RequestService.fetchData { result in
            switch result {
            case .success(let data):
                guard let notification = try? JSONDecoder().decode([Notification].self, from: data as! Data) else { return }
                DispatchQueue.main.async {
                    self.notifications = notification
                    self.notiCount = self.notifications.count
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}
