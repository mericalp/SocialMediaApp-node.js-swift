//
//  EditProfileViewController.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 1.06.2023.
//

import UIKit
import Kingfisher

class EditProfileViewController: UIViewController {
    var user: User
    private var presenter: EditProfilePresenterProtocol!
    
    // Image Picker
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    
    private var profileImage = UIButton()
    private var nameTextField = UITextField()
    private var locationTextField = UITextField()
    private let saveButton = UIButton()
   
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        KingfisherManager.shared.cache.clearCache()
        style()
        layout()
    }
    
    private func configurePresenter() {
        let interactor = EditProfileInteractor(service: NetworkManager(), user: user)
        presenter = EditProfilePresenter(view: self, interactor: interactor, router: EditProfilRouter(view: self))
        interactor.delegate = presenter as? EditProfilInteractorDelegate
    }
    
    @objc func save() {
        if selectedImage != nil {
            presenter.save(name: nameTextField.text!, location: locationTextField.text!, image: selectedImage ?? UIImage())
        } else {
            presenter.withoutImage(name: nameTextField.text!, location: locationTextField.text!)
        }
        dismiss(animated: true)
    }
    
    @objc func openLibrary() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            profileImage.setImage(selectedImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func style() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        if let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(user.id)/avatar") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImage.setImage(image, for: .normal)
                        }
                    }
                }
            }
        }
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.backgroundColor = .red
        profileImage.layer.cornerRadius = 55
        profileImage.clipsToBounds = true
        profileImage.addTarget(self, action: #selector(openLibrary), for: .touchUpInside)
        
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.borderStyle = .none
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftViewMode = .always
        nameTextField.layer.borderWidth = 2.0
        nameTextField.layer.borderColor = UIColor.peach.cgColor
        nameTextField.layer.cornerRadius = 15
        nameTextField.placeholder = "\(user.name)"

        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.borderStyle = .none
        locationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: locationTextField.frame.height))
        locationTextField.leftViewMode = .always
        locationTextField.layer.borderWidth = 2.0
        locationTextField.layer.borderColor = UIColor.peach.cgColor
        locationTextField.layer.cornerRadius = 15
        locationTextField.placeholder = "\(user.location ?? "")"

        saveButton.layer.cornerRadius = 10
        saveButton.tintColor = .white
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor.peach
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.backgroundColor = .white
        view.addSubview(nameTextField)
        view.addSubview(locationTextField)
        view.addSubview(saveButton)
        view.addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            
            profileImage.heightAnchor.constraint(equalToConstant: 110),
            profileImage.widthAnchor.constraint(equalToConstant: 110),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            nameTextField.widthAnchor.constraint(equalToConstant: Constants.TextField.width),
            nameTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.heigh),
            nameTextField.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 80),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            locationTextField.widthAnchor.constraint(equalToConstant: Constants.TextField.width),
            locationTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.heigh),
            locationTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
            locationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            saveButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: Constants.NormalButton.width),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.NormalButton.heigh),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
        ])
    }
    
}
