//
//  SceneDelegate.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 8.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        print(LocalState.jwt)
        print(LocalState.userId)
        let MainTabBarViewController = MainTabBarViewController()
        let navigationController = UINavigationController(rootViewController: MainTabBarViewController)

       
        if LocalState.jwt == nil {
            let loginViewController = UINavigationController(rootViewController: WelcomeViewController())
            window?.rootViewController = loginViewController
        } else {
            window?.rootViewController = MainTabBarViewController
        }

        window?.makeKeyAndVisible()
    }

    ///  For Log in and Log out
    func redirect(to viewController: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}

