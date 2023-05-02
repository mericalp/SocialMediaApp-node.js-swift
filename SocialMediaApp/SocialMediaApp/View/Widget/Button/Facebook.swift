//
//  Facebook.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

struct FacebookButton: View {
    var onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack{
                Image(IconItems.Social.facebook.rawValue)
                Text(LocaleKeys.Auth.facebook.rawValue.locale())
                Spacer()
            }
            .tint(.white)
            .font(.headline)
            .padding(.all,PagePadding.All.normal.rawValue)
        }
        .buttonBorderShape(.roundedRectangle(radius: 14))
        .controlSize(.large)
        .background(Color.skyblue)
        .cornerRadius(RadiusItems.radius)
    }
}

struct FacebookButton_Previews: PreviewProvider {
    static var previews: some View {
        FacebookButton {

        }
    }
}
