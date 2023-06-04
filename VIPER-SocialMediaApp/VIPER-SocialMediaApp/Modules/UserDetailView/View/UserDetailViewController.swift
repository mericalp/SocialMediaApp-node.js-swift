//
//  SearchProfileViewController.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 27.05.2023.
//

import UIKit
import Kingfisher

protocol UserDetailViewProtocol: class {
    func showLoading(_ isLoading: Bool)
    func updateUserInfo(_ user: User)
    func loadPosts(_ post: [Post])

}

class UserDetailViewController: UIViewController, UserDetailViewProtocol {
    var user: User // For Search to profile
    var user_: String? // For Home to profile
    private var presenter: UserDetailPresenterProtocol!
    var posts: [Post] = []

    init(user: User?, user_: String?) {
        self.user = user ?? User(_id: user_!, name: "", username: "", email: "", followers: [], followings: [])
        self.user_ = user_
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileImage = UIImageView()
    var settingButton = UIButton()
    var nameText = UILabel()
    var etNameText = UILabel()
    var location = UILabel()
    let locationImage = UIImageView()
    var followersText = UILabel()
    var followingText = UILabel()
    var viewStatsButton = UIButton()
    var followButton = UIButton()
    var segmentedView: ProfileSegmentedView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        presenter.loadUser(userId: user_ ?? "")
        presenter.viewDidLoad()
        style()
        layout()
        updateUserInfo(user)
    }
    
    private func configurePresenter() {
        let interactor = UserDetailInteractor(service: NetworkManager(), user: user)
        presenter = UserDetailPresenter(view: self, interactor: interactor) as! any UserDetailPresenterProtocol
        interactor.delegate = presenter as? UserDetailInteractorDelegate
    }

    func updateUserInfo(_ user: User) {
        self.user = user
        let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(user.id)/avatar")!
        profileImage.kf.setImage(with: url)
        nameText.text = user.name
        etNameText.text = "@\(user.username)"
        location.text = user.location
        followersText.text = "\(user.followers.count) Followers"
        followingText.text = "\(user.followings.count) Following"
    }
    
    func loadPosts(_ post: [Post]) {
        var filteredPosts: [Post] = []
        for postx in post {
            if postx.userId == user.id {
                filteredPosts.append(postx)
            }
        }
        self.posts = filteredPosts
        segmentedView.posts = posts
        segmentedView.reloadCollectionView()
    }
    
    func checkFollow(isFollowed: Bool) {
      let userId = LocalState.userId as! String
      if (self.user.followers.contains(userId)) {
          self.user.isFollowed = true
      } else {
          self.user.isFollowed = false
      }
    }

    func updateFollowButton(isFollowed: Bool) {
        if user.isFollowed! {
            followButton.setTitle("Following", for: .normal)
            followButton.backgroundColor = .black
            followButton.setTitleColor(.white, for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .white
            followButton.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func follow() {
        if user.isFollowed! {
            presenter.unfollow(userId: user.id)
        } else {
            presenter.follow(userId: user.id)
        }
     }
    
    func showLoading(_ isLoading: Bool) { }

    func displayError(_ message: String) {
        print("Error: \(message)")
    }

}

extension UserDetailViewController {
    func style() {
        segmentedView = ProfileSegmentedView()
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        segmentedView.posts = self.posts
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 55
        profileImage.clipsToBounds = true
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        etNameText.translatesAutoresizingMaskIntoConstraints = false
        etNameText.font = UIFont.systemFont(ofSize: 15)
        etNameText.textColor = .gray
        
        location.translatesAutoresizingMaskIntoConstraints = false
        location.font = UIFont.systemFont(ofSize: 15)
        location.textColor = .gray
        location.addSubview(locationImage)
        location.textAlignment = .left
        
        locationImage.translatesAutoresizingMaskIntoConstraints = false
        locationImage.image = UIImage(systemName: "mappin.circle.fill")!
        locationImage.tintColor = .gray
        
        followersText.translatesAutoresizingMaskIntoConstraints = false
        followersText.font = UIFont.systemFont(ofSize: 15)
        followersText.tintColor = .gray

        followingText.translatesAutoresizingMaskIntoConstraints = false
        followingText.font = UIFont.systemFont(ofSize: 15)
        followingText.tintColor = .gray
        
        viewStatsButton.translatesAutoresizingMaskIntoConstraints = false
        viewStatsButton.backgroundColor = .black
        viewStatsButton.tintColor = .white
        viewStatsButton.layer.cornerRadius = 20
        viewStatsButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        viewStatsButton.setTitle("View Stats", for: .normal)
        
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.layer.borderWidth = 2.0
        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        followButton.layer.cornerRadius = 20
        followButton.addTarget(self, action: #selector(follow), for: .touchUpInside)
    }
    
    func layout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImage)
        view.addSubview(nameText)
        view.addSubview(etNameText)
        view.addSubview(location)
        view.addSubview(followersText)
        view.addSubview(followingText)
        view.addSubview(viewStatsButton)
        view.addSubview(followButton)
        view.addSubview(segmentedView)
        
        NSLayoutConstraint.activate([
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

            followersText.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            followersText.leadingAnchor.constraint(equalTo: nameText.leadingAnchor),

            followingText.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            followingText.leadingAnchor.constraint(equalTo: followersText.trailingAnchor, constant: 10),

            viewStatsButton.heightAnchor.constraint(equalToConstant: 40),
            viewStatsButton.widthAnchor.constraint(equalToConstant: 155),
            viewStatsButton.topAnchor.constraint(equalTo: followersText.bottomAnchor, constant: 12),
            viewStatsButton.leadingAnchor.constraint(equalTo: followersText.leadingAnchor),

            followButton.heightAnchor.constraint(equalToConstant: 40),
            followButton.widthAnchor.constraint(equalToConstant: 155),
            followButton.topAnchor.constraint(equalTo: followersText.bottomAnchor, constant: 12),
            followButton.leadingAnchor.constraint(equalTo: viewStatsButton.trailingAnchor, constant: 5),
            
            segmentedView.topAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 12),
            segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
