//
//  OnboardingUserCheckResult.swift
//  ZOOC
//
//  Created by 류희재 on 2/7/24.
//

import Foundation

struct UserInfoResult: Decodable {
    let name: String?
    let phone: String?
}

extension UserInfoResult {
    
    func toDomain(_ isFirstUser: Bool,
                  _ oAuthModel: OAuthAuthenticationModel) -> OnboardingUserInfo {
        return .init(isFirstUser: isFirstUser,
                     oauthModel: oAuthModel,
                     userInfo: .init(phone: phone, name: name, marketing: nil))
    }
}
