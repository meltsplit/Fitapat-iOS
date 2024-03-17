//
//  OnboardingNameViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 3/8/24.
//

import Foundation

import RxSwift
import RxRelay


final class OnboardingNameViewModel: ViewModelType {
    
    private let useCase: OnboardingNameUseCase
    private let manager: OnboardingStateManager
    private var model: OnboardingUserInfo
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let nameTextFieldText: Observable<String>
        let nextButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let showToast = PublishRelay<String>()
        var nextButtonTitle = PublishRelay<String?>()
        var nextDestination = PublishRelay<(OnboardingDestination, OnboardingStateManager, OnboardingUserInfo)>()
    }
    
    //MARK: - Life Cycle
    
    init(
        useCase: OnboardingNameUseCase,
        manager: OnboardingStateManager,
        model: OnboardingUserInfo
    ) {
        self.useCase = useCase
        self.manager = manager
        self.model = model
    }
    
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .map { self.manager.nameButtonTitle }
            .bind(to: output.nextButtonTitle)
            .disposed(by: disposeBag)
        
        input.nameTextFieldText
            .subscribe(with: self, onNext: { owner, name in
                owner.model.userInfo.name = name
            })
            .disposed(by: disposeBag)
        
        input.nextButtonDidTap
            .map { _ in self.useCase }
            .map(manager.selectNameAction)
            .flatMap{ $0(self.model) }
            .map { (self.manager.nameDestination, self.manager, self.model) }
            .bind(to: output.nextDestination)
            .disposed(by: disposeBag)
        
        
        return output
        
    }
}
