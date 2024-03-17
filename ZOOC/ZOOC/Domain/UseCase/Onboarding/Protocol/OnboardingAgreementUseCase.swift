//
//  OnboardingAgreementUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import RxSwift
import RxCocoa

protocol OnboardingAgreementUseCase: OnboardingBaseUseCase {
    var agreementList: BehaviorRelay<[OnboardingAgreementModel]> { get set }
    var ableToSignUp: BehaviorRelay<Bool> { get }
    var showToast: PublishRelay<String> { get }
    
    func updateAllAgreementState()
    func updateAgreementState(_ index: Int)
    
}
