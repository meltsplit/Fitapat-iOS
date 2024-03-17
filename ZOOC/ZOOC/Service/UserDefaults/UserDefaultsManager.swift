//
//  UserDefaultKeyList.swift
//  ZOOC
//
//  Created by 장석우 on 2023/04/26.
//

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case fcmToken
    case zoocAccessToken
    case zoocRefreshToken
}

struct UserDefaultsManager {
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.fcmToken.rawValue, defaultValue: "none")
    static var fcmToken: String
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocAccessToken.rawValue, defaultValue: "")
    static var zoocAccessToken: String
    
    @UserDefaultWrapper<String>(key: UserDefaultKeys.zoocRefreshToken.rawValue, defaultValue: "")
    static var zoocRefreshToken: String
    
}

extension UserDefaultsManager {
    
    static func reset() {
        
        UserDefaultKeys.allCases.forEach { key in
            if key != .fcmToken {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        }
    }
}

