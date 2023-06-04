//
//  Lotti.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 24.05.2023.
//

import UIKit
import Lottie

class AnimationHelper {
    
    static func playLottieAnimation(animationName: String, inView view: UIView) {
        let animationView = LottieAnimationView(name: "welcomeIcon")
        
        
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
   
        animationView.frame = CGRect(x: view.bounds.width / 5, y: view.bounds.height / 10, width: 250, height: 250)
        animationView.loopMode = .loop
        
        view.addSubview(animationView)
       
        animationView.play()
        
    }
}



