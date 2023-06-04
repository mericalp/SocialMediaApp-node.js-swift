//
//  NotificationViewController.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 29.05.2023.
//

import UIKit
import Foundation

protocol NotificationViewControllerProtocol: AnyObject {
    func getNotification(_ noti: [Notification])
}

class NotificationViewController: UIViewController, NotificationViewControllerProtocol {
    private var presenter: NotificationPresenter!
    private var notis: [Notification] = []
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        style()
        layout()
        presenter.viewDidLoad()
    }
       
    private func configurePresenter() {
        let interactor = NotificationInteractor(service: NetworkManager())
        let router = NotificationRouter(view: self)
        presenter = NotificationPresenter(viewController: self, interactor: interactor, router: router)
        interactor.delegate = presenter as? NotificationInteractorDelegate
    }

    func displayError(_ errorMessage: String) {
        print("Error: \(errorMessage)")
    }
    
    func getNotification(_ noti: [Notification]) {
        self.notis = noti
        self.collectionView.reloadData()
    }
    
}

extension NotificationViewController {
    func style() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NotificaitonCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func layout() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
              collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
              collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 125
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NotificaitonCell
        var not = notis[indexPath.item]
        let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(not.notSenderId)/avatar")!
        cell.profileImage.kf.setImage(with: url)
        if not.notificationType == .clap {
            cell.textLabel.text = "clap your post"
        } else {
            cell.textLabel.text = "followed you"
        }
        cell.name.text = not.username
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectNotification(at: indexPath.row)
    }
    
}
 
class NotificaitonCell: UICollectionViewCell {
    var typeNoti: NotificationType?
    let profileImage = UIImageView()
    let userPhoto = UIImageView()
    let name  = UILabel()
    let textLabel  = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NotificaitonCell {
    func style() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
    
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textColor = .gray
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
        
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        userPhoto.image = UIImage(systemName: "person.fill")
        userPhoto.tintColor = .black
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.textColor = .black
    }
    
    func layout() {
        contentView.addSubview(profileImage)
        contentView.addSubview(name)
        contentView.addSubview(textLabel)
        contentView.addSubview(userPhoto)
        
        NSLayoutConstraint.activate ([
            userPhoto.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            userPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            userPhoto.heightAnchor.constraint(equalToConstant: 25),
            userPhoto.widthAnchor.constraint(equalToConstant: 25),
            
            profileImage.topAnchor.constraint(equalTo: userPhoto.topAnchor,constant: 15),
            profileImage.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor, constant: 25),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            
            name.topAnchor.constraint(equalTo: profileImage.bottomAnchor,constant: 5),
            name.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor, constant: 25),
            
            textLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            textLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            textLabel.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor, constant: 25),
        ])
    }
}
