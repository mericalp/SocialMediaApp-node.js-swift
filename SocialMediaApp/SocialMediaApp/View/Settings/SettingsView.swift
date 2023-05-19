//
//  SettingsView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 19.05.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthViewModel
    @Environment(\.presentationMode) var dismiss
    
    var body: some View {
        VStack(spacing: 2) {
            logout
            Divider()
            random1
            Divider()
            random2
            Divider()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left").resizable().frame(width: 11, height: 14).foregroundColor(.black).bold()
                }

            }
        }
    }
    @ViewBuilder
    private var logout: some View {
        Button {
        authManager.logout()
        } label: {
            HStack(spacing:12){
                Text("Logout").font(.system(size: 15).bold()).foregroundColor(.black)
                Image(systemName: "door.left.hand.open")
                .resizable()
                .frame(width: 19, height: 19)
                .foregroundColor(.red)
                Spacer()
            }
        }
        .padding(.leading,25)
        .frame(width: UIScreen.main.bounds.width, height: 70)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(16)
        }
        .cornerRadius(16)
        .padding(.horizontal,40)
    }
    
    private var random1: some View {
        HStack {
            Text("Appearence").font(.system(size: 15).bold()).foregroundColor(.black)
            Spacer()
        }
        .padding(.leading,25)
        .frame(width: UIScreen.main.bounds.width, height: 70)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(16)
        }
        .cornerRadius(16)
        .padding(.horizontal,40)
    }
    
    private var random2: some View {
        HStack {
        }
        .frame(width: UIScreen.main.bounds.width, height: 70)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(16)
        }
        .cornerRadius(16)
        .padding(.horizontal,40)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
