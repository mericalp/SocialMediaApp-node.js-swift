//
//  ProfileImage.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 3.06.2023.
//

import Foundation
import UIKit

// For ImageView
extension UIImageView {
    func setProfileImage(in imageView: UIImageView) {
        let userId = LocalState.userId as! String
        
        if let url = URL(string: "\(Path.baseUrl)\(Path.users.rawValue)/\(userId)/avatar") {
            imageView.kf.setImage(with: url)
        } else {
            // Varsayılan profil fotoğrafını yükleme işlemi veya boş bir görüntü ayarlama işlemi
            imageView.image = UIImage(named: "DefaultProfileImage")
        }
    }
}


// For UIButton
extension UIButton {
    func setProfileImage(in imageView: UIButton) {
        let userId = LocalState.userId as! String
        
    }
}


