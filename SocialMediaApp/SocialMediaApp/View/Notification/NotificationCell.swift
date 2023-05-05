//
//  NotificationCell.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import SwiftUI
import Kingfisher

struct NotificationCell: View {
    let noti: Notification
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: width, height: 1, alignment: .center)
                .foregroundColor(.gray)
                .opacity(0.3)
            
            HStack(alignment: .top) {
                Image(systemName: "person.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                VStack(alignment: .leading, spacing: 5) {
                    KFImage(URL(string: "http://localhost:3000/users/\(noti.notSenderId)/avatar"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .cornerRadius(18)
                    Text("\(noti.username) ")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text(noti.notificationType.rawValue == "follow" ? NotificationType.follow.notificationMessage : NotificationType.clap.notificationMessage)
                        .foregroundColor(.black)
                }
                Spacer(minLength: 0)
            }
            .padding(.leading, 30)
        }
    }
}

//struct NotificationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationCell()
//    }
//}
