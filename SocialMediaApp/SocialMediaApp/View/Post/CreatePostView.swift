//
//  PostView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 2.05.2023.
//

import SwiftUI
import Kingfisher

struct CreatePostView: View {
    @ObservedObject var viewModel = PostsContentViewModel()
    @Binding var show : Bool
    @State private var selectedImage: UIImage?
    @State var postImage: Image?
    @State var text = ""
    @State var width = UIScreen.main.bounds.width
    @State var openButton: Bool = false
    
    let user: User
    
    var body: some View {
        VStack {
            HStack {
                cancelButton()
                Spacer()
                sendButton()
            }
            HStack {
                avatarView()
                MultilineTextField(text: $text)
            }
            postImageSection()
        }
        .padding()
    }
    
    @ViewBuilder
    private func cancelButton() -> some View {
        Button(action: {
            self.show.toggle()
        }) {
            Text("Cancel").foregroundColor(Color.peach)
        }
    }

    @ViewBuilder
    private func sendButton() -> some View {
        Button(action: {
            self.viewModel.uploadPost(text: text, image: selectedImage)
            self.show.toggle()
        }) {
            Text("Send").padding(.all,16).font(.system(size: 13).bold())
        }
        .background {
            Rectangle()
                .fill(Color.peach)
                .cornerRadius(25)
        }
        .cornerRadius(25)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }

    @ViewBuilder
    private func avatarView() -> some View {
        VStack {
            KFImage(URL(string: "http://localhost:8000/users/\(self.user.id)/avatar"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.leading, 4)
            Spacer()
        }
    }

    @ViewBuilder
    private func imageButton() -> some View {
        Button(action: {
            self.openButton.toggle()
        }) {
            Image(systemName: "plus")
                .renderingMode(.template)
                .resizable()
                .frame(width: 25, height: 25)
                .padding()
                .rotationEffect(.degrees(openButton ? 45 : 0))
                .animation((.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0)))
        }
        .background(Color.peach)
        .foregroundColor(.white)
        .clipShape(Circle())
        .shadow(color: Color.peach, radius: 5)
        .zIndex(5)
    }

    @ViewBuilder
    private func postImageSection() -> some View {
        if postImage == nil {
            ZStack {
                imageButton()
                
                SecondryButton(open: $openButton, icon: "photo.on.rectangle.angled", color: "grad2" , offSetY: -90, selectedImage: $selectedImage, postImage: $postImage)
                SecondryButton(open: $openButton, icon: "video", color: "Blue1" , offSetX: -60, offSetY: -60, delay: 0.2, selectedImage: $selectedImage, postImage: $postImage)
                SecondryButton(open: $openButton, icon: "xmark", color: "red" , offSetX: -90,delay: 0.4, selectedImage: $selectedImage, postImage: $postImage)
            }
            .padding()
        } else if let image = postImage {
            VStack {
                HStack(alignment: .top) {
                    image
                        .resizable()
                        .scaledToFill()
                        .padding(.horizontal)
                        .frame(width: width * 0.9)
                        .cornerRadius(16)
                        .clipped()
                }
                .padding()
                Spacer()
            }
        }
    }
    
    
}





struct SecondryButton: View {
    @Binding var open: Bool
    var icon = "pencil"
    var color = "blue"
    var offSetX = 0
    var offSetY = 0
    var delay = 0.0
    @State var imagePickerRepresented: Bool = false
    @Binding var selectedImage: UIImage?
    @Binding var postImage: Image?

    var body: some View {
        Button {
            if icon == "photo.on.rectangle.angled" {
                self.imagePickerRepresented.toggle()
            }
        } label: {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 16).bold())
        }
        .padding()
        .background(Color(color))
        .mask(Circle()).offset(x: open ? CGFloat(offSetX) : 0, y: open ? CGFloat(offSetY) : 0)
        .animation(Animation.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0).delay(Double(delay)))
        .sheet(isPresented: $imagePickerRepresented) {
            loadImage()
        } content: {
            ImagePicker(image: $selectedImage)
        }
    }
}

extension SecondryButton {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        postImage = Image(uiImage: selectedImage)
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatePostView()
//    }
//}
