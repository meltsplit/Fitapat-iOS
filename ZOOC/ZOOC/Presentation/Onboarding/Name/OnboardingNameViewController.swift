//
//  OnboardingNameViewController.swift
//  ZOOC
//
//  Created by 장석우 on 3/8/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

import SnapKit

final class OnboardingNameViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: OnboardingNameViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingNameView()
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingNameViewModel) {
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
        
        rootView.nameTextField.becomeFirstResponder()
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { height in
                let y: CGFloat = height > 0 ? -height + 15 : 0
                self.rootView.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(y)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: - Custom Method
    
    private func bindUI() {
        rootView.nameTextField.rx.text.orEmpty
            .subscribe(with: self, onNext: { owner, text in
                owner.rootView.nextButton.isEnabled = text.count > 1
            })
            .disposed(by: disposeBag)
    }
    
    
    private func bindViewModel() {
        
        let input = OnboardingNameViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            nameTextFieldText: rootView.nameTextField.rx.text.orEmpty.asObservable(),
            nextButtonDidTap: rootView.nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.nextButtonTitle
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, title in
                owner.rootView.nextButton.setTitle(title, for: .normal)
                dump(title)
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, text in
                owner.showToast(text, view: owner.rootView.nextButton)
            })
            .disposed(by: disposeBag)
        
        output.nextDestination
            .asDriver(onErrorJustReturn: (.unknown, SignUpNotNeedState(), .unknown() ))
            .drive(with: self, onNext: { owner, data in
                owner.navigationOnboarding(data)
            }).disposed(by: disposeBag)
        
        output.nextButtonTitle
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, title in owner.rootView.nextButton.setTitle(title, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    
    
}
