//
//  SwiftUIView.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 4.05.2023.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}
