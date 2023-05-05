//
//  NotificationViewModel.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    let user: User
    @Published var notiCount: Int = 0
    init(user: User) {
        self.user = user
        fetchNotifications()
    }
    
    func fetchNotifications () {
        RequestService.requestDomain = "http://localhost:3000/notification/\(self.user.id)"
        RequestService.fetchData { result in
            switch result {
            case .success(let data):
                guard let notification = try? JSONDecoder().decode([Notification].self, from: data as! Data) else { return }
                DispatchQueue.main.async {
                    self.notifications = notification
                    self.notiCount = self.notifications.count
                    print("\(self.notiCount)")
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
       
    }
}
