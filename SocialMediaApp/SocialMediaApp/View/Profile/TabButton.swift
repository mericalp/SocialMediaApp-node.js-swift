//
//  TabButton.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI

struct TabButton: View {
    var title: String
    @Binding var currentTab: String
    var animation: Namespace.ID
    
    var body: some View{
        Button {
            withAnimation{
                currentTab = title
            }
        } label: {
            LazyVStack(spacing: 12){
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(currentTab == title ? .black : .gray.opacity(0.6))
                    .padding(.horizontal)
                
                if currentTab == title {
                    Capsule()
                        .fill(Color.black)
                        .frame(height: 1.2)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                } else {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 1.2)
                }
            }
        }
    }
}
