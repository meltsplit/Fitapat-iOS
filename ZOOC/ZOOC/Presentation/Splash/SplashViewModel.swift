//
//  SplashViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 1/15/24.
//

import RxSwift
import RxCocoa


typealias UserInfoDict = [AnyHashable: Any]

final class SplashViewModel: ViewModelType {
    
    private let useCase: SplashUseCase
    private let userInfo: UserInfoDict?
    
    init(
        useCase: SplashUseCase,
        userInfo: UserInfoDict?
    ) {
        self.useCase = useCase
        self.userInfo = userInfo
    }
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let exitButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let presentVersionAlert = PublishRelay<VersionState>()
        let autoLoginSuccess = PublishRelay<UserInfoDict?>()
        let autoLoginFail = PublishRelay<Void>()
        let showToast = PublishRelay<String>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppear
            .flatMap(useCase.checkVersion)
            .do(onNext: { if $0 != .latestVersion { output.presentVersionAlert.accept($0)}})
            .filter { $0 == .latestVersion }
            .map { _ in }
            .flatMap(useCase.autoLogin)
            .map { self.userInfo }
            .bind(to: output.autoLoginSuccess)
            .disposed(by: disposeBag)
        
        input.exitButtonDidTapEvent
            .flatMap(useCase.autoLogin)
            .map { self.userInfo }
            .bind(to: output.autoLoginSuccess)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        useCase.autoLoginFail
            .bind(to: output.autoLoginFail)
            .disposed(by: disposeBag)
    }
}

