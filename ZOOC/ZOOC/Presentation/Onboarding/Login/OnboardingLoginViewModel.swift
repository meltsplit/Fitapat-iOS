//
//  OnboardingLoginViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

final class OnboardingLoginViewModel: ViewModelType {
    
    private let useCase: OnboardingLoginUseCase
    private var manager: OnboardingStateManager?
    private var model: OnboardingUserInfo?
    
    init(useCase: OnboardingLoginUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let kakaoLoginButtonDidTapEvent: Observable<Void>
        let appleLoginButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var loginSucceeded = PublishRelay<Void>()
        var nextButtonTitle = PublishRelay<String>()
        var nextDestination = PublishRelay<(OnboardingDestination, OnboardingStateManager, OnboardingUserInfo)>()
        var showToast = PublishRelay<String>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.kakaoLoginButtonDidTapEvent
            .map { OAuthProviderType.kakao }
            .flatMap(useCase.userCheck)
            .do(onNext: {
                self.manager = OnboardingStateManagerFactory.create($0)
                self.model = $0
            })
            .map { _ in }
            .filter { self.manager != nil && self.model != nil }
            .map { self.manager!.selectLoginAction(self.useCase) }
            .flatMap{ $0(self.model!) }
            .map { _ in (self.manager!.loginDestination, self.manager!, self.model!) }
            .bind(to: output.nextDestination)
            .disposed(by: disposeBag)
        
        input.appleLoginButtonDidTapEvent
            .map { OAuthProviderType.apple }
            .flatMap(useCase.userCheck)
            .do(onNext: {
                self.manager = OnboardingStateManagerFactory.create($0)
                self.model = $0
            })
            .map { _ in }
            .filter { self.manager != nil && self.model != nil }
            .map { self.manager!.selectLoginAction(self.useCase) }
            .flatMap{ $0(self.model!) }
            .map { (self.manager!.loginDestination, self.manager!, self.model!) }
            .bind(to: output.nextDestination)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        useCase.loginError
            .bind(to: output.showToast)
            .disposed(by: disposeBag)
    }
}

