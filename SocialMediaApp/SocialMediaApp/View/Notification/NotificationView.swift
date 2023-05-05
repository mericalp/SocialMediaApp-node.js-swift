//
//  NotificationView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import SwiftUI

struct NotificationView: View {
    let user: User
    @ObservedObject var vm: NotificationViewModel
    init(user: User) {
        self.user = user
        self.vm =  NotificationViewModel(user: user)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.notifications) { noti in
                    NotificationCell(noti: noti)
                }
            }
        }
    }
}


//
//struct NotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationView()
//    }
//}
