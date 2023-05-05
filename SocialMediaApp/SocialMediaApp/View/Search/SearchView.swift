//
//  SearchView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 5.05.2023.
//

import SwiftUI

struct SearchView : View {
    @State var text = ""
    @State var isEditing = false
    @ObservedObject var viewModel = SearchViewModel()
    
    var users: [User] {
        return text.isEmpty ? viewModel.users : viewModel.filteredUsers(text)
    }
    
    var body : some View {
        VStack {
            ScrollView {
                SearchBar(text: $text, isEditing: $isEditing)
                    .padding(.horizontal)
                LazyVStack {
                    ForEach(users) { user in
                        NavigationLink(destination: ProfileView(user: user)) {
                            SearchUserCell(user: user)
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
