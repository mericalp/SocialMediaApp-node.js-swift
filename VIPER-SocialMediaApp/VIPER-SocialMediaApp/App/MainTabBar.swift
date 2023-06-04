//
//  MainTabBar.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 22.05.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    var isExpanded = false
    let mainButton = UIButton(type: .system)
    let button1 = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainButton.setImage(UIImage(systemName: "wand.and.rays"), for: .normal)
        mainButton.backgroundColor = UIColor.peach
        mainButton.tintColor = .white
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        view.addSubview(mainButton)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainButton.widthAnchor.constraint(equalToConstant: 50),
            mainButton.heightAnchor.constraint(equalToConstant: 50),
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        mainButton.layer.cornerRadius = 25
        mainButton.clipsToBounds = true
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: NotificationViewController())
        let vc4 = UINavigationController(rootViewController: ProfileViewController())

        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "bell")
        vc4.tabBarItem.image = UIImage(systemName: "person")

        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Notification"
        vc4.title = "Profile"
        
        tabBar.tintColor = .peach
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
    @objc func mainButtonTapped() {
        let rootVC = PostViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        present(navVC, animated: true)
    }
    
}
