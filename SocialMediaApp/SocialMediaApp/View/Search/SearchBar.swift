//
//  SearchBar.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            searchField
            cancelButton
        }
        .onTapGesture {
            isEditing = true
        }
    }
    
    @ViewBuilder
    private var searchField: some View {
        TextField("Search Twitter", text: $text)
            .padding(8)
            .padding(.horizontal, 24)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            )
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        Button(action: {
            isEditing = false
            text = ""
            UIApplication.shared.endEditing()
        }) {
            Text("Cancel")
                .foregroundColor(.black)
        }
        .padding(.trailing, 8)
        .transition(.move(edge: .trailing))
        .animation(.default)
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar()
//    }
//}
