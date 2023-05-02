//
//  Email.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

struct EmailButton: View {
    var onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack{
                Spacer()
                Text(LocaleKeys.Auth.email.rawValue.locale())
                Spacer()
            }
            .tint(.white)
            .font(.headline)
            .padding(.all,PagePadding.All.normal.rawValue)
        }
        .buttonBorderShape(.roundedRectangle(radius: 14))
        .controlSize(.large)
        .background(Color.blue1)
        .cornerRadius(RadiusItems.radius)
    }
}

struct EmailButton_Previews: PreviewProvider {
    static var previews: some View {
        EmailButton {
            
        }
    }
}
