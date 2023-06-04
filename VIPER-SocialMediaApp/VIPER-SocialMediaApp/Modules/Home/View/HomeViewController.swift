//
//  HomeViewController.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 8.05.2023.
//

import Kingfisher
import UIKit
import Lottie

protocol HomeViewControllerProtocol: AnyObject {
    func showLoading(_ isLoading: Bool)
    func getPosts(_ post: [Post])
}

class HomeViewController: UIViewController, HomeViewControllerProtocol {
    private var presenter: HomePresenterProtocol!
    private var posts: [Post] = []

    let refreshControl = UIRefreshControl()
    var collectionView: UICollectionView!
    
    private var loadingAnimationView = LottieAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        style()
        layout()
        presenter.viewDidLoad()
        presenter.checkIfUserClapPost(post: posts)
        showLoading(true)
    }
    
    private func configurePresenter() {
        let interactor = HomeInteractor(service: NetworkManager())
        let router = HomeRouter(viewController: self)
        presenter = HomePresenter(view: self, interactor: interactor, router: router)
        interactor.delegate = presenter as? HomeInteractorDelegate
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loadingAnimationView.play()
            loadingAnimationView.isHidden = false
        } else {
            loadingAnimationView.stop()
            loadingAnimationView.isHidden = true
        }
    }
    
    func getPosts(_ post: [Post]) {
        posts = post
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.collectionView.reloadData()
            self.endRefreshing()
            self.showLoading(false)
        }
    }
    
    @objc func refreshData() {
        presenter.viewDidLoad()
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
}

extension HomeViewController {
    func style() {
        
        view.backgroundColor = .systemBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingAnimationView = LottieAnimationView(name: "welcomeIcon")
        loadingAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func layout() {
        view.addSubview(collectionView)
        view.addSubview(loadingAnimationView)
        
        NSLayoutConstraint.activate([
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            loadingAnimationView.widthAnchor.constraint(equalToConstant: 600),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 360
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        var post = posts[indexPath.item]
        cell.configure(with: post, presenter: presenter as! HomePresenter)
        
        if let currentUser = LocalState.userId as? String {
            if post.likes.contains(currentUser) {
                post.didClap = true
                cell.clapButton.setImage(UIImage(systemName: "hands.clap.fill"), for: .normal)
            } else {
                post.didClap = false
                cell.clapButton.setImage(UIImage(systemName: "hands.clap"),for: .normal)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectPost(at: indexPath.row)
    }
}

class CustomCell: UICollectionViewCell {
    var post: Post?
    var presenter: HomePresenter?
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let textLabel = UILabel()
    let imageView = UIImageView()
    let buttonStackView = UIStackView()
    let lassoButton = UIButton()
    let clapButton = UIButton()
    let bookmarkButton = UIButton()
    let linkButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with post: Post, presenter: HomePresenter) {
        self.post = post
        self.presenter = presenter
        nameLabel.text = post.username
        usernameLabel.text = "@" + post.username
        textLabel.text = post.text
        let postUrl = URL(string: "\(Path.baseUrl)\(Path.post.rawValue)/\(post.id)/image")!
        imageView.kf.setImage(with: postUrl)
        let profileUrl = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(post.userId)/avatar")!
        profileImageView.kf.setImage(with: profileUrl)
    }
    
    @objc private func clapPost() {
        if ((post?.didClap) != nil) {
            print("it has not been  clapp")
            presenter?.unclapPost(post: post!)
        } else {
            print("it has been clapp")
            presenter?.clapPost(post: post!)
        }
    }

}

extension CustomCell {
    func style() {
        profileImageView.backgroundColor = .peach
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = imageView.frame.size.width / 2
        
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .gray
        usernameLabel.font = UIFont.systemFont(ofSize: 15)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 40
        
        lassoButton.tintColor = .black
        lassoButton.setImage(UIImage(systemName: "lasso"), for: .normal)
        
        clapButton.tintColor = .black
        clapButton.setImage(UIImage(systemName: "hands.clap"), for: .normal)
        clapButton.addTarget(self, action: #selector(clapPost), for: .touchUpInside)
        
        bookmarkButton.tintColor = .black
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
        linkButton.tintColor = .black
        linkButton.setImage(UIImage(systemName: "link"), for: .normal)
        
    }
    
    func layout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(lassoButton)
        buttonStackView.addArrangedSubview(clapButton)
        buttonStackView.addArrangedSubview(bookmarkButton)
        buttonStackView.addArrangedSubview(linkButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -180),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
        ])
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -115),
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 25),
            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -120),
        ])
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: 40),
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -130),
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 320),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            buttonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            lassoButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            lassoButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            lassoButton.heightAnchor.constraint(equalToConstant: 28),
            lassoButton.widthAnchor.constraint(equalToConstant: 28),
        ])
        
        NSLayoutConstraint.activate([
            clapButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            clapButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            clapButton.heightAnchor.constraint(equalToConstant: 28),
            clapButton.widthAnchor.constraint(equalToConstant: 28),
        ])
        
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            bookmarkButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 28),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 28),
        ])
        
        NSLayoutConstraint.activate([
            linkButton.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            linkButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            linkButton.heightAnchor.constraint(equalToConstant: 28),
            linkButton.widthAnchor.constraint(equalToConstant: 28),
        ])
    }
    
}
