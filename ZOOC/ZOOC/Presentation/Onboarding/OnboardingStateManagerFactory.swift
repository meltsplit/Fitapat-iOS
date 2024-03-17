//
//  OnboardingManager.swift
//  ZOOC
//
//  Created by 장석우 on 3/8/24.
//

import Foundation

typealias OnboardingStateManager = OnboardingActionSelector & OnboardingNavigationState

struct OnboardingStateManagerFactory {
    
    static func create(_ model: OnboardingUserInfo) -> OnboardingStateManager {
        let name = model.userInfo.name
        let phone = model.userInfo.name
        
        if model.isFirstUser  {
            if name == nil && phone == nil {
                return SignUpNeedBothState()
            } else if name == nil {
                return SignUpNeedNameState()
            } else if phone == nil {
                return SignUpNeedPhoneState()
            } else {
                return SignUpNotNeedState()
            }
        } else {
            if name == nil && phone == nil {
                return SignInNeedBothState()
            } else if name == nil {
                return SignInNeedNameState()
            } else if phone == nil {
                return SignInNeedPhoneState()
            } else {
                return SignInNotNeedState()
            }
        }
        
    }
}



