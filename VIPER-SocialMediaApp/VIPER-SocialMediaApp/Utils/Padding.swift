//
//  Padding.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 22.05.2023.
//

import UIKit

struct Padding {
    var top: CGFloat = 0.0
    var left: CGFloat = 0.0
    var bottom: CGFloat = 0.0
    var right: CGFloat = 0.0
}

extension UIView {
    func applyPadding(_ padding: Padding) {
        self.layoutMargins = UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)
    }
}
