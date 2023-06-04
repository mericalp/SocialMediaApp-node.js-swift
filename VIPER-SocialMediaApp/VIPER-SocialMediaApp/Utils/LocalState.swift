//
//  LocalState.swift
//  VIPER-SocialMediaApp
//
//  Created by Meric Alp on 23.05.2023.
//

import Foundation


public class LocalState {
    
    private enum Keys: String {
        case jwt
        case userId
    }

    public static var jwt: Any? {
        get {
            return UserDefaults.standard.object(forKey:"jsonwebtoken")
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "jsonwebtoken")
        }
    }
    
    public static var userId: Any? {
        get {
            return UserDefaults.standard.object(forKey:"userId") 
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "userId")
        }
    }
}
