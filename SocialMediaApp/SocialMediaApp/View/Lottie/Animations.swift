//
//  Animations.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI
import Lottie

struct LottieAnimationView: UIViewRepresentable {
    var jsonFile: String
    func makeUIView(context: Context) -> some UIView {
        let rootView = UIView()
        rootView.backgroundColor = .clear
        
        let animationView = AnimationView(name: jsonFile,bundle: .main)
        animationView.backgroundColor = .clear
        animationView.loopMode = .loop
        animationView.play()
        
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            animationView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
        ]
        rootView.addConstraints(constraints)
        rootView.addSubview(animationView)
      
        return rootView
        
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
