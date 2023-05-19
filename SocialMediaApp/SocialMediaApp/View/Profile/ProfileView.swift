//
//  ProfileView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    let user: User
    @ObservedObject var viewModel: ProfileViewModel
    var isCurrentUser: Bool { return viewModel.user.isCurrentUser ?? false}
    var isFollowed: Bool { return viewModel.user.isFollowed ?? false}
    @EnvironmentObject var authManager: AuthViewModel
    @StateObject private var profileImageLoader = ImageLoader()

    // For Smooth Slide Animation...
    @Namespace var animation
    // For Dark Mode Adoption..
    @Environment(\.colorScheme) var colorScheme
    
    @State var currentTab = "Posts"
    @State var offset: CGFloat = 0
    @State var tabBarOffset: CGFloat = 0
    @State var titleOffset: CGFloat = 0
    @State private var selectedImage: UIImage?
    @State var profileImage: Image?
    @State var imagePickerRepresented = false
    @State var editProfileShow = false
    @State var width = UIScreen.main.bounds.width
    
    
    init(user: User) {
        self.user = user
        self.viewModel = ProfileViewModel(user: user)
    }

    var body: some View {
         ScrollView(.vertical, showsIndicators: false) {
             VStack(spacing: 15) {
                 
                 profileImageView
                 profileBioView
                 customSegmentedMenuView
                 sampleTweetsView
             }
             .padding(.top,40)
             .padding(.horizontal)
         }
     }
    
    
    @ViewBuilder
     private var profileImageView: some View {
         
         VStack {
             HStack {
                 VStack {
                     if profileImage == nil {
                         let profileImage = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(self.viewModel.user.id)/avatar")!
                         Button {
                             self.imagePickerRepresented.toggle()
                         } label: {
                             profileImageLoader.image?
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(width: 75, height: 75)
                                 .clipShape(Circle())
                                 .padding(8)
                                 .background(colorScheme == .dark ? Color.black : Color.white)
                                 .clipShape(Circle())
                         }.onAppear {
                             profileImageLoader.loadImage(from: profileImage)
                         }
                         
                     } else if let image = profileImage {
                         VStack {
                             HStack(alignment: .top) {
                                 image
                                     .resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: 75, height: 75)
                                     .background(Color.peach)
                                     .clipShape(Circle())
                                     .padding(8)
                                     .background(colorScheme == .dark ? Color.black : Color.white)
                                     .clipShape(Circle())
                             }.padding()
                             Spacer()
                         }
                     }
                 }
                 Spacer()
                 
                 Button{
                     authManager.logout()
                 } label: {
                     Image(systemName: "gearshape")
                         .foregroundColor(.black)
                 }
                 .padding(.top)
             }
             .padding(.top, -25)
             .padding(.bottom, -10)
         }
     }
    
    @ViewBuilder
     private var profileBioView: some View {
         HStack {
             VStack(alignment: .leading, spacing: 8) {
                 Text(viewModel.user.name)
                     .font(.title2)
                     .fontWeight(.bold)
                     .foregroundColor(.primary)
                 Text("@\(viewModel.user.username)")
                     .foregroundColor(.gray)
                 
                 HStack(spacing: 8) {
                     if let userLocation = viewModel.user.location, !userLocation.isEmpty {
                         HStack(spacing: 2) {
                             Image(systemName: "mappin.circle.fill")
                                 .frame(width: 24, height: 24)
                                 .foregroundColor(.gray)
                             Text(userLocation)
                                 .foregroundColor(.gray)
                                 .font(.system(size: 14))
                         }
                     }
                     if let userWebsite = viewModel.user.website, !userWebsite.isEmpty {
                         HStack(spacing: 2) {
                             Image(systemName: "link")
                                 .frame(width: 24, height: 24)
                                 .foregroundColor(.gray)
                             Text(userWebsite)
                                 .foregroundColor(Color("twitter"))
                                 .font(.system(size: 14))
                         }
                     }
                 }
                 
                 HStack(spacing: 5) {
                     Text("45")
                         .foregroundColor(.primary)
                         .fontWeight(.semibold)
                     Text("Followers")
                         .font(.system(size: 14))
                         .foregroundColor(.black).opacity(0.7)
                     Text("68")
                         .foregroundColor(.primary)
                         .fontWeight(.semibold)
                         .padding(.leading,10)
                     Text("Following")
                         .foregroundColor(.gray)
                 }
                 .padding(.top, 8)
                 
                 HStack {
                     Button { } label: {
                         Text("View stats")
                             .padding(.leading,20)
                             .foregroundColor(.white)
                             .padding(.trailing,25)
                             .padding(.vertical,10)
                             .padding(.horizontal)
                             .background(
                                 Rectangle()
                                     .fill(Color.black)
                                     .cornerRadius(25)
                             )
                             .cornerRadius(25)
                     }
                     
                     if (self.isCurrentUser) {
                         Button {
                             editProfileShow.toggle()
                         } label: {
                             Text("Edit your profile")
                                 .foregroundColor(.black)
                                 .padding(.leading,10)
                                 .padding(.trailing,8)
                                 .padding(.vertical,10)
                                 .padding(.horizontal)
                                 .background(
                                     Capsule()
                                         .stroke(Color.black, lineWidth: 1.5)
                                 )
                         }
                         .onAppear {
                             print("called")
                             KingfisherManager.shared.cache.clearCache()
                         }
                         .sheet(isPresented: $editProfileShow, onDismiss: {
                             KingfisherManager.shared.cache.clearCache()
                             AuthViewModel.shared.fetchUser(userId: viewModel.user.id)
                         }, content: {
                             EditProfileView(user: $viewModel.user)
                         })
                     } else {
                         Button {
                             isFollowed ? self.viewModel.unfollow() : self.viewModel.follow()
                         } label: {
                             Text(isFollowed ? "Following" : "Follow")
                                 .foregroundColor(isFollowed ? .black : .white)
                                 .padding(.vertical, 10)
                                 .padding(.horizontal)
                                 .background(
                                     ZStack {
                                         Capsule()
                                             .stroke(Color.black, lineWidth: isFollowed ? 1.5 : 0)
                                             .foregroundColor(isFollowed ? .white : .black)
                                         Capsule()
                                             .foregroundColor(isFollowed ? .white : .black)
                                     }
                             )
                         }
                     }
                 }
             }
             .padding(.leading, 8)
             Spacer()
         }
     }
    @ViewBuilder
     private var customSegmentedMenuView: some View {
         VStack(spacing: 0) {
             ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 0) {
                     TabButton(title: "Posts", currentTab: $currentTab, animation: animation)
                     TabButton(title: "Lists", currentTab: $currentTab, animation: animation)
                     TabButton(title: "About", currentTab: $currentTab, animation: animation)
                 }
             }
             Divider()
         }
         .padding(.top,30)
         .background(colorScheme == .dark ? Color.black : Color.white)
     }
     
    @ViewBuilder
     private var sampleTweetsView: some View {
         VStack(spacing: 18) {
             ForEach(viewModel.posts) { post in
                 PostCell(viewModel: PostCellViewModel(post: post, currentUser: AuthViewModel.shared.currentUser!))
                 Divider()
             }
         }
         .padding(.top)
         .zIndex(0)
     }

}

extension View {
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}

extension ProfileView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

