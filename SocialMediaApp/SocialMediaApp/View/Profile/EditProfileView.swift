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
    
    @State var name: String
    @State var location: String
    @State var bio: String
    @State var website: String
    
    @State private var selectedImage: UIImage?
    @State var profileImage: Image?
    @State var imagePickerRepresented = false
    @State var editProfileShow = false

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
        
                HStack {
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text("Edit profile")
                            .fontWeight(.heavy)
                        Spacer()
                    }
                    
                    
                }.padding()
                
            VStack {
                Image("banner")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: getRect().width, height: 180, alignment: .center)
                    .cornerRadius(0)
                HStack {
                    if profileImage == nil {
                        Button {
                            self.imagePickerRepresented.toggle()
                        } label: {
                            Text("asd")
                            KFImage(URL(string: "http://localhost:3000/users/\(self.viewModel.user.id)/avatar"))
                                .resizable()
                                .placeholder({
                                    Image("blankpp")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 75, height: 75)
                                        .clipShape(Circle())
                                })
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(y: -20)
                                .padding(.leading, 12)
                        }
                        .sheet(isPresented: $imagePickerRepresented) {
                            loadImage()
                        } content: {
                            ImagePicker(image: $selectedImage)
                        }
                    } else if let image = profileImage {
                        VStack {
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
                        }.padding(.leading, 12)
                    }
                    Spacer()
                }
                .onAppear {
                    KingfisherManager.shared.cache.clearCache()
                }
                .padding(.top, -25)
                .padding(.bottom, -10)
                
                VStack {
                    
                    
                    Button {
                        if (selectedImage != nil) {
                            print("With image")
                            self.viewModel.uploadProfileImage(text: "text", image: selectedImage)
                            self.viewModel.uploadUserData(name: name, bio: bio, website: website, location: location)
                            KingfisherManager.shared.cache.clearCache()
                        }
                        else {
                            print("Without image")
                            self.viewModel.uploadUserData(name: name, bio: bio, website: website, location: location)
                        }
                    } label: {
                        Text("Save")
                            .foregroundColor(.black)
                    }
                    Divider()
                    HStack {
                        ZStack {
                            HStack {
                                Text("Name")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            TextField("Add your name", text: $name)
                           
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                    
                    HStack {
                        ZStack {
                            HStack {
                                Text("Location")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            TextField("Add your location", text: $location).padding(.leading, 90)
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                    
                    HStack {
                        ZStack(alignment: .topLeading) {
                            HStack {
                                Text("Bio")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            
                            TextField("", text: $bio)
                         
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                    
                    HStack {
                        ZStack(alignment: .topLeading) {
                            HStack {
                                Text("Website")
                                    .foregroundColor(.black)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            TextField("Add your website", text: $website)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
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
