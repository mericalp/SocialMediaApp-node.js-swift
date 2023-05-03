//
//  Color.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

extension GeometryProxy {
    
    /// Dynamic Height by device
    /// - Parameter height: Percent value
    /// - Returns: Calculated value for device height
    func dh(height: Double) -> Double {
        return size.height * height
    }
    
    /// Dynmaic Width by device
    /// - Parameter width: percent value
    /// - Returns: calculated value for device height
    func dw(width: Double) -> Double {
        return size.width * width
    }
}

extension Color {
    public static var pink1: Color { Color("Pink1") }
    public static var pink2: Color { Color("Pink2") }
    public static var blue1: Color { Color("Blue1") }
    public static var blue2: Color { Color("Blue2") }
    public static var skyblue: Color { Color("skyBlue") }
    public static var peach: Color { Color("peach") }
    public static var grad1: Color { Color("grad1") }
    public static var grad2: Color { Color("grad2") }
    public static var red: Color { Color("red") }
}

extension LinearGradient {
    public static var linerGradient: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color.blue1,Color.blue2]), startPoint: .leading, endPoint: .trailing) }
    public static var linerGradient2: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color.pink1,Color.pink2]), startPoint: .leading, endPoint: .trailing) }
    public static var linerGradient3: LinearGradient { LinearGradient(gradient: Gradient(colors: [Color.grad1,Color.grad2]), startPoint: .leading, endPoint: .trailing) }

}
