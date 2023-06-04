//
//  SettingsView.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 31.05.2023.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    func displayError(_ message: String)
}

class SettingsViewController: UIViewController, SettingsViewProtocol {
    var presenter: SettingsPresenter!

    private var logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        style()
        layout()
    }

    private func configurePresenter() {
        let interactor = SettingsInteractor(service: NetworkManager())
        let router = SettingsRouter(view: self, delegate: SceneDelegate())
        presenter = SettingsPresenter(view: self, interactor: interactor, router: router)
        interactor.delegate = presenter as? SettingsInteractorDelegate
    }

    @objc func logout() {
        presenter.logout()
    }

    func displayError(_ message: String) { }
}

extension SettingsViewController {
    func style() {
        logoutButton.backgroundColor = UIColor.systemGray5
        logoutButton.setImage(UIImage(systemName: "door.left.hand.open"), for: .normal)
        logoutButton.setTitle(" Logout", for: .normal)
        logoutButton.tintColor = .red
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate ([
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 120),
            logoutButton.widthAnchor.constraint(equalToConstant: 420),
            logoutButton.heightAnchor.constraint(equalToConstant:  Constants.NormalButton.heigh),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
