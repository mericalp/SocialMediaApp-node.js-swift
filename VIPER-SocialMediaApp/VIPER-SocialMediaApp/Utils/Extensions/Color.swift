//
//  Color.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 22.05.2023.
//

import UIKit

extension UIColor {
    static var pink1: UIColor { UIColor(named: "Pink1") ?? .clear }
    static var pink2: UIColor { UIColor(named: "Pink2") ?? .clear }
    static var blue1: UIColor { UIColor(named: "Blue1") ?? .clear }
    static var blue2: UIColor { UIColor(named: "Blue2") ?? .clear }
    static var skyblue: UIColor { UIColor(named: "skyBlue") ?? .clear }
    static var peach: UIColor { UIColor(named: "peach") ?? .clear }
    static var grad1: UIColor { UIColor(named: "grad1") ?? .clear }
    static var grad2: UIColor { UIColor(named: "grad2") ?? .clear }
    static var red: UIColor { UIColor(named: "red") ?? .clear }
}

//extension LinearGradient {
//    public static var linerGradient: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color.blue1,Color.blue2]), startPoint: .leading, endPoint: .trailing) }
//    public static var linerGradient2: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color.pink1,Color.pink2]), startPoint: .leading, endPoint: .trailing) }
//    public static var linerGradient3: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color.grad1,Color.grad2]), startPoint: .leading, endPoint: .trailing) }
//
//}

extension UIView {
    func applyLinearGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

