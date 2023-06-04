//
//  SignInViewController.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 22.05.2023.
//

import UIKit


protocol LoginViewProtocol: AnyObject {
    func displayError(error: Error)
}

class LoginViewController: UIViewController, LoginViewProtocol {
    var presenter: LoginPresenterProtocol!

    private let welcomeLabel = UILabel()
    private let loginLabel = UILabel()
    private let stackView = UIStackView()
    private let spacerView = UIStackView()
    private var usernameTextField = UITextField()
    private var nameTextField = UITextField()
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let containerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        style()
        layout()
    }

    func configurePresenter() {
        let interactor = LoginInteractor(service: NetworkManager())
        let router = LoginRouter(view: self, delegate: SceneDelegate())
        presenter = LoginPresenter(view: self, interactor: interactor, router: router)
        interactor.delegate = presenter as? LoginInteractorDelegate
    }
    
    @objc func logginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {  return }
        presenter?.loginButtonTapped(email: email, password: password)
    }

    func displayError(error: Error) { }
}

extension LoginViewController {
    func style() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome \nBack"
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        welcomeLabel.textColor = .white
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "Login"
        loginLabel.font = UIFont.systemFont(ofSize: 25,weight: .bold)
        loginLabel.textColor = .black
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .none
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: emailTextField.frame.height))
        emailTextField.leftViewMode = .always
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = UIColor.blue1.cgColor
        emailTextField.layer.cornerRadius = 15
        
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.axis = .vertical
        spacerView.spacing = 70
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .none
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordTextField.frame.height))
        passwordTextField.leftViewMode = .always
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor = UIColor.blue1.cgColor
        passwordTextField.layer.cornerRadius = 15

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 10
        loginButton.tintColor = .white
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor.blue2
        loginButton.addTarget(self, action: #selector(logginButtonTapped), for: .touchUpInside)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        
    }
    
    func layout() {
        view.backgroundColor = UIColor.blue2
        view.addSubview(welcomeLabel)
        view.addSubview(loginLabel)
        view.addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(loginButton)
        
        NSLayoutConstraint.activate([
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
        containerView.heightAnchor.constraint(equalToConstant: view.bounds.height / 1.7),
        
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
        
        loginLabel.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: 205),
        loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
        welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        
        emailTextField.widthAnchor.constraint(equalToConstant: Constants.TextField.width),
        emailTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.heigh),
        
        passwordTextField.widthAnchor.constraint(equalToConstant: Constants.TextField.width),
        passwordTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.heigh),
        
        usernameTextField.widthAnchor.constraint(equalToConstant: Constants.TextField.width),
        usernameTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.heigh),
        
        nameTextField.widthAnchor.constraint(equalToConstant: Constants.TextField.width),
        nameTextField.heightAnchor.constraint(equalToConstant: Constants.TextField.heigh),
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 70),
        loginButton.widthAnchor.constraint(equalToConstant: Constants.NormalButton.width),
        loginButton.heightAnchor.constraint(equalToConstant: Constants.NormalButton.heigh),
        ])
        
   
    }
    
}
