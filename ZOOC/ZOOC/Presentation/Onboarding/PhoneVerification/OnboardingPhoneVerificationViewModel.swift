//
//  OnboardingPhoneVerificationViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 3/5/24.
//

import Foundation

import RxSwift
import RxRelay

enum PhoneVertificationError : Error {
    case timeOut
    case incorrectCode
    
    var message: String {
        switch self {
        case .timeOut:
            return "재전송 버튼을 눌러 다시 인증해주세요"
        case .incorrectCode:
            return "올바른 인증번호를 입력해주세요"
        }
    }
}

final class OnboardingPhoneVerificationViewModel: ViewModelType {
    
    private let useCase: OnboardingPhoneVerificationUseCase
    private let manager: OnboardingStateManager
    private var model: OnboardingUserInfo
    private var timer: Timer?
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let sendButtonDidTap: Observable<Void>
        let signUpButtonDidTap: Observable<Void>
        let phoneTextFieldText: Observable<String>
        let codeTextFieldText : Observable<String>
    }
    
    struct Output {
        let verifySuccess = PublishRelay<Void>()
        let verifyFail = PublishRelay<PhoneVertificationError>()
        let showToast = PublishRelay<String>()
        let timeLeft = BehaviorRelay<Int>(value: 90)
        let activateSignUpButton = PublishRelay<Bool>()
        var nextButtonTitle = PublishRelay<String?>()
        var nextDestination = PublishRelay<(OnboardingDestination, OnboardingStateManager, OnboardingUserInfo)>()
    }
    
    //MARK: - Life Cycle
    
    init(
        useCase: OnboardingPhoneVerificationUseCase,
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
            .map { self.manager.phoneButtonTitle }
            .bind(to: output.nextButtonTitle)
            .disposed(by: disposeBag)
        
        input.phoneTextFieldText
            .subscribe(with: self, onNext: { owner, phone in
                let phoneWithoutHypen = phone
                    .replacingOccurrences(of: "-", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                owner.model.userInfo.phone = phoneWithoutHypen
            })
            .disposed(by: disposeBag)
        
        input.sendButtonDidTap
            .do(onNext: { [weak self] in
                guard let self else { return}
                self.timer?.invalidate()
                self.timer = nil
                output.timeLeft.accept(90)
                self.timer = Timer.scheduledTimer(
                    withTimeInterval: 1,
                    repeats: true) { _ in
                        guard output.timeLeft.value > 0 else {
                            output.verifyFail.accept(.timeOut)
                            self.timer?.invalidate()
                            self.timer = nil
                            return
                        }
                        output.timeLeft.accept(output.timeLeft.value - 1)
                     
                    }
            })
            .withLatestFrom(input.phoneTextFieldText)
            .flatMap(useCase.sendVertificationCode)
            .map { _ in "인증번호를 발송했어요" }
            .bind(to: output.showToast)
            .disposed(by: disposeBag)
        
        input.signUpButtonDidTap
            .withLatestFrom(input.codeTextFieldText)
            .map(useCase.verify)
            .do(onNext: { if $0 == false { output.verifyFail.accept(.incorrectCode )}})
            .filter { $0 }
            .map { _ in self.useCase }
            .map(manager.selectPhoneAction)
            .flatMap { $0(self.model) }
            .map { (self.manager.phoneDestination, self.manager, self.model) }
            .bind(to: output.nextDestination)
            .disposed(by: disposeBag)
        
        input.codeTextFieldText
            .map { $0.count == 6 && output.timeLeft.value >= 0}
            .bind(to: output.activateSignUpButton)
            .disposed(by: disposeBag)
        
        
        return output
        
    }
}
