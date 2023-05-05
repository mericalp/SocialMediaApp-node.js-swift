//
//  CustomAlertView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var shown: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 10) {
                Image(systemName: "star.circle").resizable().frame(width: 30, height: 30).foregroundColor(.black)
                Text("Your registration has been created successfully").font(.system(size: 15).bold())
            }
            Button {
                shown.toggle()
            } label: {
                Text("Ok").foregroundColor(.black).font(.system(size: 16).bold())
            }
            .padding(15)
            .padding(.leading,35)
            .padding(.trailing,35)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .cornerRadius(25)
            }
        }
        .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.width / 1.5, alignment: .center)
        .background {
            Rectangle()
                .fill(Color.green).opacity(0.4)
                .cornerRadius(25)
        }
    }
}

//struct CustomAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomAlertView()
//    }
//}
