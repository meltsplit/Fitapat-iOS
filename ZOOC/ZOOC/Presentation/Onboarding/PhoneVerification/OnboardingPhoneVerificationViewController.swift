//
//  OnboardingPhoneNumberViewController.swift
//  ZOOC
//
//  Created by 장석우 on 3/5/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

import SnapKit

final class OnboardingPhoneVerificationViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: OnboardingPhoneVerificationViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingPhoneVerificationView()
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingPhoneVerificationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.title = "정보 입력"
        
        bindUI()
        bindViewModel()
        dismissKeyboardWhenTappedAround(cancelsTouchesInView: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView.phoneTextField.becomeFirstResponder()
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { height in
                let y: CGFloat = height > 0 ? -height + 15 : 0
                self.rootView.signUpButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(y)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.phoneTextField.rx.text.orEmpty
            .subscribe(with: self, onNext: { owner, text in
                owner.rootView.sendButton.isEnabled = text.count > 12
            })
            .disposed(by: disposeBag)
        
        rootView.sendButton.rx.tap
            .subscribe(with: self, onNext: {owner, _ in
                owner.rootView.resetUI()
                owner.rootView.sendButton.isEnabled = false
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindViewModel() {
        
        let input = OnboardingPhoneVerificationViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            sendButtonDidTap: rootView.sendButton.rx.tap.asObservable(),
            signUpButtonDidTap: rootView.signUpButton.rx.tap.asObservable(),
            phoneTextFieldText: rootView.phoneTextField.rx.text.orEmpty.asObservable(),
            codeTextFieldText: rootView.codeTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.timeLeft
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: rootView.updateTimerLabel)
            .disposed(by: disposeBag)
        
        output.verifySuccess
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, _ in
                print("성공")
            })
            .disposed(by: disposeBag)
        
        output.verifyFail
            .asDriver(onErrorJustReturn: .incorrectCode)
            .drive(with: self, onNext: { owner, error in
                owner.rootView.codeTextField.setBorder(width: 1, color: .zw_red)
                owner.rootView.failLabel.text = error.message
                owner.rootView.failLabel.isHidden = false
                switch error {
                case .incorrectCode:
                    return 
                case .timeOut:
                    owner.rootView.signUpButton.isEnabled = false
                    owner.rootView.timerLabel.textColor = .zw_red
                }
            })
            .disposed(by: disposeBag)
        
        
        output.showToast
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, text in
                owner.showToast(text, view: owner.rootView.signUpButton)
            })
            .disposed(by: disposeBag)
        
        output.activateSignUpButton
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isEnabled in
                owner.rootView.signUpButton.isEnabled = isEnabled
                if isEnabled { owner.rootView.failLabel.isHidden = true }
            })
            .disposed(by: disposeBag)
        
        output.nextDestination
            .asDriver(onErrorJustReturn: (.unknown, SignUpNotNeedState(), .unknown() ))
            .drive(with: self, onNext: { owner, data in
                owner.navigationOnboarding(data)
            }).disposed(by: disposeBag)
        
        output.nextButtonTitle
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, title in 
                owner.rootView.signUpButton.setTitle(title, for: .normal)
                dump(title)
            })
            .disposed(by: disposeBag)
    }
    
}
