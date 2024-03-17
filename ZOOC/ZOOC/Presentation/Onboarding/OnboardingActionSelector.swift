//
//  OnboardingActionSelector.swift
//  ZOOC
//
//  Created by 장석우 on 3/12/24.
//

import RxSwift
import RxRelay

protocol OnboardingActionSelector {
    
    func selectLoginAction(
        _ usecase: OnboardingLoginUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void>
    
    func selectAgreementAction(
        _ usecase: OnboardingAgreementUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void>
    
    func selectNameAction(
        _ usecase: OnboardingNameUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void>
    
    func selectPhoneAction(
        _ usecase: OnboardingPhoneVerificationUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void>
}


extension OnboardingActionSelector {
    
    func selectLoginAction(
        _ usecase: OnboardingLoginUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void> {
        
        return { _ in .just(())}
    }
    
    func selectAgreementAction(
        _ usecase: OnboardingAgreementUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void> {
        
        return { _ in .just(())}
    }
    
    func selectNameAction(
        _ usecase: OnboardingNameUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void> {
        
        return { _ in .just(())}
    }
    
    func selectPhoneAction(
        _ usecase: OnboardingPhoneVerificationUseCase
    ) -> (OnboardingUserInfo) -> Observable<Void> {
        
        return { _ in .just(())}
    }
}
