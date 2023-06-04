//
//  ProfileViewControler.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 25.05.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewProtocol: class {
    func showLoading(_ isLoading: Bool)
    func updateUserLabel(_ user: User)
    func loadPosts(_ post: [Post])
}

class ProfileViewController: UIViewController, ProfileViewProtocol {
    var user: User?
    var posts: [Post] = []
    private var presenter: ProfilePresenterProtocol!
    
    var SettingButton = UIButton()
    var profileImage = UIImageView()
    var nameText = UILabel()
    var etNameText = UILabel()
    var location = UILabel()
    let locationImage = UIImageView()
    var followersText = UILabel()
    var followingText = UILabel()
    var viewStatsButton = UIButton()
    var editProfileButton = UIButton()
    var segmentedView: ProfileSegmentedView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurePresenter()
        presenter.viewDidLoad()
        style()
        layout()
    }
    
    private func configurePresenter() {
        let interactor = ProfileInteractor(service: NetworkManager())
        let router = ProfileRouter(viewController: self)
        presenter = ProfilePresenter(view: self, interactor: interactor, router: router)
        interactor.delegate = presenter as? ProfileInteractorDelegate
    }
    
    func showLoading(_ isLoading: Bool) {    }
    
    func updateUserLabel(_ user: User) {
        self.user = user
        nameText.text = user.name
        etNameText.text = "@\(user.username)"
        location.text = user.location
        followersText.text = "\(user.followers.count) Folowers"
        followingText.text = " \(user.followings.count) Following"
        let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(user.id)/avatar")
        profileImage.kf.setImage(with: url)
    }
    
    func loadPosts(_ post: [Post]) {
        var currentUserId = LocalState.userId as! String
        var filteredPosts: [Post] = []
        for postx in post {
            if postx.userId == currentUserId {
                filteredPosts.append(postx)
            }
        }
        self.posts = filteredPosts
        segmentedView.posts = posts
        segmentedView.reloadCollectionView()
    }
    
    @objc func editProfile() {
        presenter.editProfileButtonTapped(user!)
    }

    func displayError(_ message: String) {
        print("Error: \(message)")
    }
    
    @objc func toSettingsView() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ProfileViewController {
    func style() {
        segmentedView = ProfileSegmentedView()
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        segmentedView.posts = self.posts
        
        SettingButton.translatesAutoresizingMaskIntoConstraints = false
        SettingButton.setTitle("asd", for: .normal)
        SettingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        SettingButton.tintColor = .gray
        SettingButton.addTarget(self, action: #selector(toSettingsView), for: .touchUpInside)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.backgroundColor = .red
        profileImage.layer.cornerRadius = 55
        profileImage.clipsToBounds = true
        
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        etNameText.translatesAutoresizingMaskIntoConstraints = false
        etNameText.font = UIFont.systemFont(ofSize: 15)
        etNameText.textColor = .gray
        
        location.translatesAutoresizingMaskIntoConstraints = false
        location.font = UIFont.systemFont(ofSize: 15)
        location.textColor = .gray
        location.textAlignment = .left
        
        locationImage.translatesAutoresizingMaskIntoConstraints = false
        locationImage.image = UIImage(systemName: "mappin.circle.fill")
        locationImage.tintColor = .gray
        
        followingText.translatesAutoresizingMaskIntoConstraints = false
        followingText.font = UIFont.systemFont(ofSize: 15)
        followingText.tintColor = .gray
        
        followersText.translatesAutoresizingMaskIntoConstraints = false
        followersText.font = UIFont.systemFont(ofSize: 15)
        followersText.tintColor = .gray
        
        viewStatsButton.backgroundColor = .black
        viewStatsButton.tintColor = .white
        viewStatsButton.translatesAutoresizingMaskIntoConstraints = false
        viewStatsButton.layer.cornerRadius = 20
        viewStatsButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        viewStatsButton.setTitle("View Stats", for: .normal)
        
        editProfileButton.setTitleColor(.black, for: .normal)
        editProfileButton.layer.borderWidth = 2.0
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        editProfileButton.layer.cornerRadius = 20
        editProfileButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.setTitle("Edit Your Profile", for: .normal)
        
    }
    
    func layout() {
        view.addSubview(SettingButton)
        view.addSubview(profileImage)
        view.addSubview(nameText)
        view.addSubview(etNameText)
        view.addSubview(location)
        location.addSubview(locationImage)
        view.addSubview(followersText)
        view.addSubview(followingText)
        view.addSubview(viewStatsButton)
        view.addSubview(editProfileButton)
        view.addSubview(segmentedView)

        NSLayoutConstraint.activate([
            SettingButton.widthAnchor.constraint(equalToConstant: 20),
            SettingButton.heightAnchor.constraint(equalToConstant: 20),
            SettingButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            SettingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            
            profileImage.heightAnchor.constraint(equalToConstant: 110),
            profileImage.widthAnchor.constraint(equalToConstant: 110),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            nameText.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            nameText.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 20),

            etNameText.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 10),
            etNameText.leadingAnchor.constraint(equalTo: nameText.leadingAnchor),

            location.topAnchor.constraint(equalTo: etNameText.bottomAnchor, constant: 10),
            location.leadingAnchor.constraint(equalTo: etNameText.leadingAnchor, constant: 20),
            
            locationImage.widthAnchor.constraint(equalToConstant: 20),
            locationImage.heightAnchor.constraint(equalToConstant: 20),
      

            followersText.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            followersText.leadingAnchor.constraint(equalTo: nameText.leadingAnchor),

            followingText.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            followingText.leadingAnchor.constraint(equalTo: followersText.trailingAnchor, constant: 10),

            viewStatsButton.heightAnchor.constraint(equalToConstant: 40),
            viewStatsButton.widthAnchor.constraint(equalToConstant: 155),
            viewStatsButton.topAnchor.constraint(equalTo: followersText.bottomAnchor, constant: 12),
            viewStatsButton.leadingAnchor.constraint(equalTo: followersText.leadingAnchor),

            editProfileButton.heightAnchor.constraint(equalToConstant: 40),
            editProfileButton.widthAnchor.constraint(equalToConstant: 155),
            editProfileButton.topAnchor.constraint(equalTo: followersText.bottomAnchor, constant: 12),
            editProfileButton.leadingAnchor.constraint(equalTo: viewStatsButton.trailingAnchor, constant: 5),
            
            segmentedView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 12),
            segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
