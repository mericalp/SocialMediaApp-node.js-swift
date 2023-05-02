//
//  Google.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

struct GoogleButton: View {
    var onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack{
                Image(IconItems.Social.google.rawValue)
                Text(LocaleKeys.Auth.google.rawValue.locale())
                Spacer()
            }
            .tint(.black)
            .font(.headline)
            .padding(.all,PagePadding.All.normal.rawValue)
        }
        .buttonBorderShape(.roundedRectangle(radius: 14))
        .controlSize(.large)
        .background(.white)
        .cornerRadius(RadiusItems.radius)

    }
}

struct GoogleButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleButton {
            
        }
    }
}
