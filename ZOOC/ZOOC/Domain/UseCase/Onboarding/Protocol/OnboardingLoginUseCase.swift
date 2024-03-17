//
//  OnboardingLoginUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import RxSwift
import RxCocoa

protocol OnboardingLoginUseCase: OnboardingBaseUseCase {
    func userCheck(_ serviceType: OAuthProviderType) -> Observable<OnboardingUserInfo>
}

