//
//  LocaleKeys.swift
//  SocialMediaApp
//
//  Created by Meric Alp on 1.05.2023.
//

import SwiftUI

struct LocaleKeys {
    enum Auth: String {
        case facebook = "signInFacebook"
        case google = "signInGoogle"
        case apple = "signInApple"
        case email = "signupWithEmail"
    }
}

extension String {
    /// It localize any string from localizable string
    /// - Returns: Localized value
    func locale() -> LocalizedStringKey {
        return LocalizedStringKey(self)
    }
}
