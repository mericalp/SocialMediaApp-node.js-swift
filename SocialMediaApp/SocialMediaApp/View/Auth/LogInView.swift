//
//  LogInView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//
import SwiftUI


struct LogInView: View {
    @State var shown: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height: geometry.dh(height: 0.05))
                LoginHeaderView().blur(radius: shown ? 30 : 0)
                if shown {
                    CustomAlertView(shown: $shown)
                }
                LoginBodyView(shown: $shown).blur(radius: shown ? 30 : 0)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .leading)
            .background(LinearGradient.linerGradient)
            .ignoresSafeArea()
        }
    }
}

struct LoginHeaderView: View {
    var body: some View {
        VStack {
            Text(" Welcome \n Back").font(.system(size: FontSizes.XXLargeTitle,weight: .bold)).foregroundColor(.white)
        }
        .frame(width: UIScreen.main.bounds.width, height: 240, alignment: .leading)
    }
}

struct LoginBodyView: View {
    @State var registerUser : Bool = false
    @State private var isShowingDetailView = false
    @EnvironmentObject var authManager: AuthViewModel
    @Binding var shown: Bool

    var body: some View {
          ScrollView(showsIndicators: false) {
              header()
              form()
            
          }
      }
    
    private func header() -> some View {
        HStack {
            Text(registerUser ? "  Register Now" :"   Login")
                .font(.system(size: FontSizes.largeTitle, weight: .bold))
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
    }

    private func form() -> some View {
        VStack(spacing: 27) {
            Spacer().frame(height: 11)
            
            if registerUser {
                TextField("username", text: $authManager.username)
                    .modifier(CustomModifier())
            }
            
            if registerUser {
                TextField("name", text: $authManager.name)
                    .modifier(CustomModifier())
            }
            
            TextField("Email", text: $authManager.email)
                .modifier(CustomModifier())
            
            SecureField("Password", text: $authManager.password)
                .modifier(CustomModifier())
            
            toggleButton()
            
            actionButton()
            
            Spacer().frame(height: 410)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        .background(.thickMaterial)
        .cornerRadius(55)
    }

    private func toggleButton() -> some View {
        Button {
            withAnimation {
                registerUser.toggle()
            }
        } label: {
            HStack(spacing: 5) {
                Text(registerUser ? "   Have an account?" : "   Not a remember?" ).font(.system(size: 16))
                Text(registerUser ? " Back to login" : "Create Account").font(.system(size: 16))
                    .foregroundColor(.blue)
                Spacer().frame(width: 12)
            }
        }
    }

    private func actionButton() -> some View {
        Button {
            if registerUser {
                authManager.register()
                shown.toggle()
                authManager.username = ""
                authManager.name = ""
                authManager.email = ""
                authManager.password = ""
                registerUser = false
            } else {
                authManager.login()
                print(authManager.isAuthenticated)
            }
        } label: {
            HStack {
                Text(registerUser ? "Sign Up" : "Login").font(.system(size: 22).bold())
                    .foregroundColor(.white)
            }
            .frame(width: ViewWidth.buttonWeight, height: ViewHeight.buttonHeight, alignment: .center)
            .padding()
            .background(LinearGradient.linerGradient)
            .cornerRadius(12)
        }
        .buttonStyle(.bordered)
    }

   
}

struct CustomModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 330, height: 18, alignment: .leading)
            .padding()
            .background(.white)
            .cornerRadius(35)
            .overlay{
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue1,lineWidth: 2)
            }
     }
}
