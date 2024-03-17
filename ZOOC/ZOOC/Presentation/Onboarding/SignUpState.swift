//
//  SignUpState.swift
//  ZOOC
//
//  Created by 장석우 on 3/8/24.
//

import RxSwift

//MARK: - <회원가입> 둘 다 필요할 때

struct SignUpNeedBothState: OnboardingNavigationState {
    
    var agreementButtonTitle: String? = "다음"
    var nameButtonTitle: String? = "다음"
    var phoneButtonTitle: String? = "회원가입"
    
    var loginDestination: OnboardingDestination = .agreement
    var agreementDestination: OnboardingDestination = .name
    var nameDestination: OnboardingDestination = .phone
    var phoneDestination: OnboardingDestination = .welcome
}

extension SignUpNeedBothState: OnboardingActionSelector {
    
    func selectPhoneAction(_ usecase: OnboardingPhoneVerificationUseCase) -> (OnboardingUserInfo) -> RxSwift.Observable<Void> {
        return usecase.signUp
    }
}


//MARK: - <회원가입> 번호만 필요할 때

struct SignUpNeedPhoneState: OnboardingNavigationState {
    
    var agreementButtonTitle: String? = "다음"
    var phoneButtonTitle: String? = "회원가입"
    
    var loginDestination: OnboardingDestination = .agreement
    var agreementDestination: OnboardingDestination = .phone
    var phoneDestination: OnboardingDestination = .welcome
    
}

extension SignUpNeedPhoneState: OnboardingActionSelector {
    
    func selectPhoneAction(_ usecase: OnboardingPhoneVerificationUseCase) -> (OnboardingUserInfo) -> RxSwift.Observable<Void> {
        return usecase.signUp
    }
}

//MARK: - <회원가입> 이름만 필요할 때

struct SignUpNeedNameState: OnboardingNavigationState {
    
    var agreementButtonTitle: String? = "다음"
    var nameButtonTitle: String? = "회원가입"
    
    var loginDestination: OnboardingDestination = .agreement
    var agreementDestination: OnboardingDestination = .name
    var nameDestination: OnboardingDestination = .welcome
    
}

extension SignUpNeedNameState: OnboardingActionSelector {
    
    func selectNameAction(_ usecase: OnboardingNameUseCase) -> (OnboardingUserInfo) -> RxSwift.Observable<Void> {
        return usecase.signUp
    }
}

//MARK: - <회원가입> 아무것도 필요하지 않을 때

struct SignUpNotNeedState: OnboardingNavigationState {
    
    var agreementButtonTitle: String? = "회원가입"
    
    var loginDestination: OnboardingDestination = .agreement
    var agreementDestination: OnboardingDestination = .welcome
}

extension SignUpNotNeedState: OnboardingActionSelector {

    func selectAgreementAction(_ usecase: OnboardingAgreementUseCase) -> (OnboardingUserInfo) -> RxSwift.Observable<Void> {
        return usecase.signUp
    }

}
