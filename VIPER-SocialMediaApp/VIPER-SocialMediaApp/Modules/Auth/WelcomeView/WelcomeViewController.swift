//
//  WelcomeViewController.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import UIKit

class WelcomeViewController: UIViewController, UINavigationControllerDelegate {
    
    private let stackView = UIStackView()
    private let stackView2 = UIStackView()
    private let SignInButton = UIButton()
    private let SignUpButton = UIButton()
    
    private let Lottie: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        AnimationHelper.playLottieAnimation(animationName: "animation", inView: view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }

    @objc func goToSignIn() {
        let signInViewController = LoginViewController()
        navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    @objc func goToSignUp() {
        let signUpViewController = RegisterViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
}


extension WelcomeViewController {
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.axis = .vertical
        stackView2.spacing = 12
     
        SignInButton.translatesAutoresizingMaskIntoConstraints = false
        SignInButton.backgroundColor = .blue2
        SignInButton.setTitle("Sign In", for: .normal)
        SignInButton.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        SignInButton.layer.cornerRadius = 20
        SignInButton.setTitleColor(.white, for: .normal)
        SignInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        SignUpButton.translatesAutoresizingMaskIntoConstraints = false
        SignUpButton.backgroundColor = .blue1
        SignUpButton.layer.cornerRadius = 20
        SignUpButton.setTitle("Sign Up ", for: .normal)
        SignUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        SignUpButton.setTitleColor(.white, for: .normal)
        SignUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    
    func layout() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue2.cgColor, UIColor.blue1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.applyLinearGradient(colors: [UIColor.blue2, UIColor.blue1], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        
        navigationController?.delegate = self
   
        view.addSubview(Lottie)
        view.addSubview(stackView)
        view.addSubview(stackView2)
        let button1 = createCustomButton(image: UIImage(named: "google")!, title: "   Google",backgroundColor: .white, tintColor: .black)
        let button2 = createCustomButton(image: UIImage(named: "facebook")!, title: "   Facebook",backgroundColor: .skyblue, tintColor: .white)
        let button3 = createCustomButton(image: UIImage(named: "apple")!, title: "   Apple",backgroundColor: .black, tintColor: .white)
        
        stackView.addSubview(button2)
        stackView.addSubview(button1)
        stackView.addSubview(button3)
        stackView2.addArrangedSubview(SignUpButton)
        stackView2.addArrangedSubview(SignInButton)
        
        setupButton(button2, button1, button3)
        
        NSLayoutConstraint.activate([
            Lottie.topAnchor.constraint(equalTo: view.topAnchor),
            Lottie.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
            
            stackView.topAnchor.constraint(equalTo: Lottie.topAnchor, constant: 300),
            stackView.bottomAnchor.constraint(equalTo: stackView2.topAnchor, constant: 120),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -180),
        
            
            SignUpButton.topAnchor.constraint(equalTo: stackView2.topAnchor, constant: 10),
            SignUpButton.centerXAnchor.constraint(equalTo: stackView2.centerXAnchor),
            SignUpButton.widthAnchor.constraint(equalToConstant: Constants.LoginButton.width),
            SignUpButton.heightAnchor.constraint(equalToConstant: Constants.LoginButton.heigh),
            
            SignInButton.topAnchor.constraint(equalTo: SignUpButton.bottomAnchor, constant: 20),
            SignInButton.centerXAnchor.constraint(equalTo: stackView2.centerXAnchor),
            SignInButton.widthAnchor.constraint(equalToConstant: Constants.LoginButton.width),
            SignInButton.heightAnchor.constraint(equalToConstant: Constants.LoginButton.heigh),
    
            
            stackView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -166),
            stackView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func createCustomButton(image: UIImage, title: String, backgroundColor: UIColor, tintColor: UIColor) -> UIButton {
       let button = UIButton()
       button.translatesAutoresizingMaskIntoConstraints = false
       button.backgroundColor = backgroundColor
       button.setImage(image, for: .normal)
       button.setTitle(title, for: .normal)
       button.setTitleColor(tintColor, for: .normal)
       button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
       button.layer.cornerRadius = 20
       
       let stackView = UIStackView(arrangedSubviews: [button.imageView!, button.titleLabel!])
       stackView.axis = .horizontal
       stackView.alignment = .center
       stackView.spacing = 2
       
     
       button.addSubview(stackView)
       stackView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
           stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
           stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
       ])
       
     return button
    }
    
    func setupButton(_ buttons: UIButton...) {
  
        for button in buttons {
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
                button.widthAnchor.constraint(equalToConstant: Constants.LoginButton.width),
                button.heightAnchor.constraint(equalToConstant: Constants.LoginButton.heigh)
            ])
        }
        
        NSLayoutConstraint.activate([
            buttons[0].topAnchor.constraint(equalTo: stackView.topAnchor,constant: 10),
            buttons[1].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 5),
            buttons[2].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 5)
        ])
    }
    
    
    
}
