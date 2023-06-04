//
//  zz.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 29.05.2023.
//

import UIKit
import Kingfisher

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var presenter: PostCreatePresenterProtocol?
    var user: User?
    
    // Image Picker
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    var isExpanded = false
    
    let profileImage = UIImageView()
    let mainButton = UIButton(type: .system)
    let photoButton = UIButton(type: .system)
    let videoButton = UIButton(type: .system)
    let xmarkButton = UIButton(type: .system)
    let imageView = UIImageView()
    let cancelButton = UIButton(type: .system)
    let sendButton = UIButton(type: .system)
    let textField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = LocalState.userId as! String
        configurePresenter()
        presenter?.viewDidLoad()
        style()
        layout()
    }
    
    private func configurePresenter() {
        let interactor = PostCreateInteractor()
        presenter = PostCreatePresenter(view: self, interactor: interactor)
        interactor.delegate = presenter as? PostCreateInteractorDelegate
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendTapped() {
        presenter?.postCreateButtonTapped(text: textField.text ?? "", image: selectedImage, user: user!)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonTapped() {    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = selectedImage
            print(image)
        }
        dismiss(animated: true, completion: nil)
    }

    @objc func mainButtonTapped() {
        if isExpanded {
            UIView.animate(withDuration: 0.3, animations: {
                self.photoButton.alpha = 0
                self.videoButton.alpha = 0
                self.xmarkButton.alpha = 0
            }) { _ in
                self.photoButton.removeFromSuperview()
                self.videoButton.removeFromSuperview()
                self.xmarkButton.removeFromSuperview()
            }
            mainButton.setImage(UIImage(systemName: "plus"), for: .normal)
        } else {
                mainButton.setImage(UIImage(systemName: "xmark"), for: .normal)

            view.addSubview(photoButton)
            view.addSubview(videoButton)
            view.addSubview(xmarkButton)
       
            photoButton.translatesAutoresizingMaskIntoConstraints = false
            videoButton.translatesAutoresizingMaskIntoConstraints = false
            xmarkButton.translatesAutoresizingMaskIntoConstraints = false
       
            NSLayoutConstraint.activate([
                photoButton.widthAnchor.constraint(equalToConstant: 40),
                photoButton.heightAnchor.constraint(equalToConstant: 40),
                photoButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -25),
                photoButton.trailingAnchor.constraint(equalTo: mainButton.trailingAnchor, constant: -10),
               
                videoButton.widthAnchor.constraint(equalToConstant: 40),
                videoButton.heightAnchor.constraint(equalToConstant: 40),
                videoButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor),
                videoButton.leadingAnchor.constraint(equalTo: mainButton.leadingAnchor, constant: -48),
                
                xmarkButton.widthAnchor.constraint(equalToConstant: 40),
                xmarkButton.heightAnchor.constraint(equalToConstant: 40),
                xmarkButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: 50),
                xmarkButton.leadingAnchor.constraint(equalTo: mainButton.leadingAnchor, constant: -70),
              
            ])
            photoButton.layer.cornerRadius = 20
            photoButton.clipsToBounds = true
            videoButton.layer.cornerRadius = 20
            videoButton.clipsToBounds = true
            xmarkButton.layer.cornerRadius = 20
            xmarkButton.clipsToBounds = true
            photoButton.alpha = 0
            videoButton.alpha = 0
            xmarkButton.alpha = 0
       
            UIView.animate(withDuration: 1.5) {
                self.photoButton.alpha = 2
                self.videoButton.alpha = 10
                self.xmarkButton.alpha = 20
            }
        }
        isExpanded.toggle()
    }
    
    @objc func photoButtonTapped() {
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func videoButtonTapped() {     }
    @objc func xmarkButtonTapped() {     }
    
}

extension PostViewController {
    func style() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        profileImage.setProfileImage(in: profileImage)
        profileImage.backgroundColor = .peach
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type Something..."
        textField.tintColor = .black
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = UIColor.peach
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.tintColor = UIColor.white
        sendButton.backgroundColor = .peach
        sendButton.layer.cornerRadius = 16
        sendButton.clipsToBounds = true
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.setImage(UIImage(systemName: "plus"), for: .normal)
        mainButton.backgroundColor = UIColor.peach
        mainButton.tintColor = .white
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        mainButton.layer.cornerRadius = 25
        mainButton.clipsToBounds = true
        
        photoButton.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        photoButton.backgroundColor = UIColor.grad2
        photoButton.tintColor = .white
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
        videoButton.setImage(UIImage(systemName: "video"), for: .normal)
        videoButton.backgroundColor = UIColor.blue1
        videoButton.tintColor = .white
        videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        
        xmarkButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xmarkButton.backgroundColor = UIColor.red
        xmarkButton.tintColor = .white
        xmarkButton.addTarget(self, action: #selector(xmarkButtonTapped), for: .touchUpInside)
    }
    
    func layout() {
        view.backgroundColor = .white
        view.addSubview(cancelButton)
        view.addSubview(sendButton)
        view.addSubview(mainButton)
        view.addSubview(textField)
        view.addSubview(imageView)
        view.addSubview(profileImage)
         
        NSLayoutConstraint.activate([
        
            sendButton.widthAnchor.constraint(equalToConstant: 70),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 30),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            profileImage.topAnchor.constraint(equalTo: cancelButton.bottomAnchor,constant: 50),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            textField.widthAnchor.constraint(equalToConstant: 150),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -40),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 380),
            imageView.heightAnchor.constraint(equalToConstant: 280),
            imageView.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -160),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainButton.widthAnchor.constraint(equalToConstant: 50),
            mainButton.heightAnchor.constraint(equalToConstant: 50),
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
      
    }
    
}
