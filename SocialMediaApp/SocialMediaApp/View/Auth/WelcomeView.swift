//
//  WelcomeView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

struct WelcomeView: View {

    var body: some View {
        ZStack {
            LinearGradient.linerGradient3
            BodyView()
        }.ignoresSafeArea(.all)
    }
}

struct BodyView: View {

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LottieAnimationView(jsonFile: "welcomeIcon")
                Spacer()
                FacebookButton { }
                GoogleButton { }
                AppleButton { }
                Divider()
                    .background(.white)
                    .frame(width: geometry.dw(width: 0.8),height: DividerViewSize.normal)
                    .padding(.all,PagePadding.All.normal.rawValue)
                EmailButton { } .padding(.top,20)
                NavigationLink {
                    LogInView().environmentObject(AuthViewModel())
                 } label: {
                    HStack {
                        Spacer()
                        Text("Sign In With Email")
                        Spacer()
                    }
                    .tint(.white)
                    .font(.system(size: FontSizes.headLine,weight: .semibold))
                    .padding(.all,PagePadding.All.normal.rawValue)
                    .frame(width: 360, height: 50)
                }
                .buttonBorderShape(.roundedRectangle)
                .controlSize(.large)
                .background(LinearGradient.linerGradient)
                .cornerRadius(RadiusItems.radius)
                
                Spacer().frame(height: geometry.dh(height: 0.12))
            }.padding(16)
        }
    }
}
