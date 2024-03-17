//
//  DefaultOnboardingAgreementUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import RxSwift
import RxRelay

final class DefaultOnboardingAgreementUseCase: OnboardingAgreementUseCase {
    var loginError =  RxRelay.PublishRelay<String>()
    
    
    private let disposeBag = DisposeBag()
    
    let userRepository: UserRepository
    let authRepository: AuthRepository
    
    var agreementList = BehaviorRelay<[OnboardingAgreementModel]>(value: OnboardingAgreementModel.agreementData)
    var ableToSignUp = BehaviorRelay<Bool>(value: false)
    var showToast = PublishRelay<String>()
    
    init(
        authRepository: AuthRepository,
        userRepository: UserRepository   
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
}

extension DefaultOnboardingAgreementUseCase {
    func updateAllAgreementState() {
        let updateIsSelected = !ableToSignUp.value
        agreementList.take(1).map {
            return $0.map { agreement in
                var updatedAgreement = agreement
                updatedAgreement.isSelected = updateIsSelected
                return updatedAgreement
            }
        }.do(onNext: { [weak self] list in
            self?.agreementList.accept(list)
        })
        .flatMap(checkAbleToSignUp)
        .bind(to: ableToSignUp)
        .disposed(by: disposeBag)
    }
    
    func updateAgreementState(_ index: Int) {
        agreementList.take(1).map {
                var updatedAgreementList = $0
                updatedAgreementList[index].isSelected.toggle()
                return updatedAgreementList
            }.do(onNext: { [weak self] list in
                self?.agreementList.accept(list)
            })
            .flatMap(checkAbleToSignUp)
            .bind(to: ableToSignUp)
            .disposed(by: disposeBag)
    }
    
    private func checkAbleToSignUp(_ agreementList: [OnboardingAgreementModel]) -> Observable<Bool> {
        return Observable.just(agreementList.dropLast().allSatisfy { $0.isSelected})
    }
}

