//
//  GeneralButton.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

/// It's a normal button for project
///
/// [onTap] will return user interaction
/// [title] it showes button name
struct GeneralButton: View {
    var onTap: () -> Void
    var title: String
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text(title)
                Spacer()
            }
            .tint(.white)
            .font(.system(size: FontSizes.headLine,weight: .semibold))
            .padding(.all,PagePadding.All.normal.rawValue)
        }
        .buttonBorderShape(.roundedRectangle)
        .controlSize(.large)
        .background(LinearGradient.linerGradient)
        .cornerRadius(RadiusItems.radius)
    }
}

struct NormalButton_Previews: PreviewProvider {
    static var previews: some View {
        GeneralButton(onTap: {
            
        }, title: "Sample")
    }
}
