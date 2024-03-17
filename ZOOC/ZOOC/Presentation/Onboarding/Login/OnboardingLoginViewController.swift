//
//  OnboardingLoginViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingLoginViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: OnboardingLoginViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingLoginView()
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingLoginViewModel) {
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
        
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    private func bindViewModel() {
        
//        rootView.kakaoLoginButton.rx.tap
//            .subscribe(onNext: {
//                let vc = DIContainer.shared.makePhoneVerificationVC()
//                self.navigationController?.pushViewController(vc, animated: true)
//            })
//            .disposed(by: disposeBag)
        
        let input = OnboardingLoginViewModel.Input(
            kakaoLoginButtonDidTapEvent: rootView.kakaoLoginButton.rx.tap
                .throttle(.seconds(2),latest: false, scheduler: MainScheduler.instance)
                .map { _ in () }
                .asObservable(),
            appleLoginButtonDidTapEvent: rootView.appleLoginButton.rx.tap
                .throttle(.seconds(2),latest: false, scheduler: MainScheduler.instance)
                .map { _ in () }
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.loginSucceeded
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, autoLoginSucceded in
                let tbc = DIContainer.shared.makeTabBarController()
                UIApplication.shared.changeRootViewController(tbc)
            }).disposed(by: disposeBag)
        
        output.nextDestination
            .asDriver(onErrorJustReturn: (.unknown, SignUpNotNeedState(), .unknown() ))
            .drive(with: self, onNext: { owner, data in
                owner.navigationOnboarding(data)
            }).disposed(by: disposeBag)
        
        output.showToast
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: presentToast)
            .disposed(by: disposeBag)
        
 
    }
}
