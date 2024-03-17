//
//  OnboardingRequest.swift
//  ZOOC
//
//  Created by 장석우 on 3/7/24.
//

import Foundation

struct UserInfo {
    var phone: String?
    var name: String?
    var marketing: Bool?
    
    
    func toData() -> UserInfoRequest {
        return UserInfoRequest(agreement: AgreementRequest(marketing: marketing ?? false),
                               name: name,
                               phone: phone)
    }
}
