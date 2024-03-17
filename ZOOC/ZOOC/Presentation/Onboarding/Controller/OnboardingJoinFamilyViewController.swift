//
//  OnboardingParticipateViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingJoinFamilyViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: OnboardingJoinFamilyViewModel
    
    //MARK: - UI Components
    
    private let rootView = OnboardingJoinFamilyView.init(onboardingState: .processCodeReceived)
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingJoinFamilyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    func bindUI() {
        rootView.backButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = OnboardingJoinFamilyViewModel.Input (
            familyCodeTextFieldDidChangeEvent: rootView.familyCodeTextField.rx.text.asObservable(),
            nextButtonDidTapEvent: rootView.nextButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.enteredCode
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, enteredCode in
                owner.rootView.familyCodeTextField.text = enteredCode
            }).disposed(by: disposeBag)
        
        output.ableToCheckCode
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, ableToCheckCode in
                owner.rootView.nextButton.isEnabled = ableToCheckCode
            }).disposed(by: disposeBag)
        
        output.errMessage
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, errMessage in
                guard let errMessage else { return }
                owner.showToast(errMessage, type: .bad)
            }).disposed(by: disposeBag)
        
    }
}

extension OnboardingJoinFamilyViewController {
    private func pushToJoinCompletedViewController() {
        let joinCompletedVC = OnboardingJoinFamilyCompletedViewController()
        self.navigationController?.pushViewController(joinCompletedVC, animated: true)
    }
}
