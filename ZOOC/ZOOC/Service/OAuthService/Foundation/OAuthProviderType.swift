//
//  OAuthProviderType.swift
//  ZOOC
//
//  Created by 류희재 on 1/8/24.
//

import Foundation

/**
 - description: OAuth 서비스를 제공하는 제공자 종류
    우리 서비스의 경우 Apple, Kakao 서비스 사용
 */

enum OAuthProviderType: String, Hashable, CaseIterable {
    case kakao
    case apple
    
    var service: OAuthServiceType {
        switch self {
        case .kakao:
            return OAuthKakaoService()
        case .apple:
            return OAuthAppleService()
        }
    }
}
