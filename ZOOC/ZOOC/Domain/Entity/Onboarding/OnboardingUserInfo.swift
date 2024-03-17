//
//  OnboardingEntity.swift
//  ZOOC
//
//  Created by 장석우 on 3/7/24.
//

import Foundation

struct OnboardingUserInfo {
    let isFirstUser: Bool
    let oauthModel: OAuthAuthenticationModel
    var userInfo: UserInfo
    
    static func unknown() -> OnboardingUserInfo {
        return .init(isFirstUser: false, 
                     oauthModel: .init(oauthType: .kakao, oauthToken: ""),
                     userInfo: .init())
    }
}


