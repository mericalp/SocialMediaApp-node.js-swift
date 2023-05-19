//
//  EditProfileView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    @Environment(\.presentationMode) var mode
    @ObservedObject var viewModel: EditProfileViewModel
    @Binding var user: User
    @StateObject private var profileImageLoader = ImageLoader()

    @State private var name: String
    @State private var location: String
    @State private var bio: String
    @State private var website: String
    
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var imagePickerRepresented = false
    
    
    init(user: Binding<User>) {
        self._user = user
        self.viewModel = EditProfileViewModel(user: self._user.wrappedValue)
        self._name = State(initialValue: _user.name.wrappedValue ?? "")
        self._website = State(initialValue: _user.website.wrappedValue ?? "")
        self._bio = State(initialValue: _user.bio.wrappedValue ?? "")
        self._location = State(initialValue: _user.location.wrappedValue ?? "")
    }
    
    var body: some View {
        VStack {
            headerView
            Spacer()
            VStack {
                Spacer()
                Spacer()
                HStack {
                    if profileImage == nil {
                        profileImageButton
                    } else if let image = profileImage {
                        VStack {
                            profileImageView(image: image)
                        }
                        .padding(.leading, 12)
                    }
                    Spacer()
                }
                .onAppear {
                    KingfisherManager.shared.cache.clearCache()
                }
                .padding(.top, -25)
                .padding(.bottom, -10)
                
                VStack {
                    nameTextField
                    
                    locationTextField
                    
                   
                    saveButton
                    Spacer()
                }
            }
            
          
        }
        .onReceive(viewModel.$uploadComplete) { complete in
            if complete {
                self.mode.wrappedValue.dismiss()
                
                self.user.name = viewModel.user.name
                self.user.website = viewModel.user.website
                self.user.location = viewModel.user.location
                self.user.bio = viewModel.user.bio
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            Text("Edit profile")
                .fontWeight(.heavy)
            Spacer()
        }
        .padding()
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.mode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
                .foregroundColor(.black)
        }
    }
    
    private var profileImageButton: some View {

        Button(action: {
            self.imagePickerRepresented.toggle()
        }) {
            VStack(spacing: 8) {
                if let image = profileImageLoader.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(y: -20)
                        .padding(.leading, 12)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .padding(8)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                        .offset(y: -20)
                        .padding(.leading, 12)
                }
            }
        }
        .sheet(isPresented: $imagePickerRepresented) {
            loadImage()
        } content: {
            ImagePicker(image: $selectedImage)
        }
        .onAppear {
            let profileImageURL = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(self.viewModel.user.id)/avatar")!
            profileImageLoader.loadImage(from: profileImageURL)
        }
        .padding(.top,30)
    }
    
    private func profileImageView(image: Image) -> some View {
        HStack(alignment: .top) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 75, height: 75)
                .clipShape(Circle())
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
                .offset(y: -20)
        }
        .padding()
    }
    
    private var saveButton: some View {
        Button(action: {
            if selectedImage != nil {
                print("With image")
                self.viewModel.uploadProfileImage(text: "text", image: selectedImage)
                self.viewModel.uploadUserData(name: name, bio: bio, website: website, location: location)
                KingfisherManager.shared.cache.clearCache()
            } else {
                print("Without image")
                self.viewModel.uploadUserData(name: name, bio: bio, website: website, location: location)
            }
        }) {
            Text("Save").padding(.all,20).font(.system(size: 16).bold())
                .padding(.horizontal,50)
        }
        .background {
            Rectangle()
                .fill(Color.peach)
                .cornerRadius(25)
        }
        .cornerRadius(25)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .padding(.top)
    }
    
    private var nameTextField: some View {
        VStack(spacing: 6){
            Text("Username").font(.system(size: 15).bold()).foregroundColor(.black)
            TextField("Add your name", text: $name)
                .modifier(CustomModifier2())
                .padding(.horizontal)
        }
    }
    
    private var locationTextField: some View {
        VStack(spacing: 6){
            Text("Location").font(.system(size: 15).bold()).foregroundColor(.black)
            TextField("Add your location", text: $location)
                .modifier(CustomModifier2())
                .padding(.horizontal)
        }
    }
    
}

struct CustomModifier2: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 330, height: 18, alignment: .leading)
            .padding()
            .background(.white)
            .cornerRadius(35)
            .overlay{
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.peach,lineWidth: 2)
            }
     }
}

extension EditProfileView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}


//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView()
//    }
//}
