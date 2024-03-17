//
//  OnboardingAgreementViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/02/22.
//

import Foundation

import RxSwift
import RxCocoa

final class OnboardingAgreementViewModel: ViewModelType {
    
    private let useCase: OnboardingAgreementUseCase
    private let manager: OnboardingStateManager
    private var model: OnboardingUserInfo
    
    init(useCase: OnboardingAgreementUseCase,
         manager: OnboardingStateManager,
         model: OnboardingUserInfo
    ) {
        self.useCase = useCase
        self.manager = manager
        self.model = model
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let allAgreementCheckButtonDidTapEvent: Observable<Void>
        let agreementCheckButtonDidTapEvent: Observable<Int>
        let nextButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var allChecked = BehaviorRelay<Bool>(value: false)
        var ableToSignUp = BehaviorRelay<Bool>(value: false)
        var agreementList = BehaviorRelay<[OnboardingAgreementModel]>(value: OnboardingAgreementModel.agreementData)
        var showToast = PublishRelay<String>()
        var nextButtonTitle = PublishRelay<String?>()
        var nextDestination = PublishRelay<(OnboardingDestination, OnboardingStateManager, OnboardingUserInfo)>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewDidLoad
            .map { self.manager.agreementButtonTitle }
            .bind(to: output.nextButtonTitle)
            .disposed(by: disposeBag)
        
        input.allAgreementCheckButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.useCase.updateAllAgreementState()
        }).disposed(by: disposeBag)
        
        input.agreementCheckButtonDidTapEvent.subscribe(with: self, onNext: { owner, index in
            owner.useCase.updateAgreementState(index)
        }).disposed(by: disposeBag)
        
        input.nextButtonDidTapEvent
            .do(onNext: {
                self.model.userInfo.marketing = self.useCase.agreementList.value.last?.isSelected
            })
            .map { _ in self.useCase }
            .map(manager.selectAgreementAction)
            .flatMap { $0(self.model) }
            .map { (self.manager.agreementDestination, self.manager, self.model) }
            .bind(to: output.nextDestination)
            .disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        useCase.agreementList
            .bind(to: output.agreementList)
            .disposed(by: disposeBag)
        
        useCase.showToast
            .bind(to: output.showToast)
            .disposed(by: disposeBag)
        
        useCase.ableToSignUp
            .do(onNext: { canSignUp in
                output.allChecked.accept(
                    canSignUp && output.agreementList.value[3].isSelected
                )
            })
            .bind(to: output.ableToSignUp)
            .disposed(by: disposeBag)
    }
}
