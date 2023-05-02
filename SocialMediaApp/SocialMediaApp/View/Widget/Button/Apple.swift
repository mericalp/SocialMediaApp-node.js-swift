//
//  Apple.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

struct AppleButton: View {
    var onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack{
                Image(IconItems.Social.apple.rawValue)
                Text(LocaleKeys.Auth.apple.rawValue.locale())
                Spacer()
            }
            .tint(.white)
            .font(.headline)
            .padding(.all,PagePadding.All.normal.rawValue)
        }
        .buttonBorderShape(.roundedRectangle(radius: 14))
        .controlSize(.large)
        .background(.black)
        .cornerRadius(RadiusItems.radius)
    }
}

struct AppleButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleButton {
            
        }
    }
}
