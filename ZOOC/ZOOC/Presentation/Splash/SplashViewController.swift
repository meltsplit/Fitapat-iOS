//
//  SplashViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/16.
//

import UIKit

import RxSwift

final class SplashViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: SplashViewModel
    private let disposeBag = DisposeBag()
    
    private let exitButtonDidTapSubject = PublishSubject<Void>()
    
    //MARK: - UI Components
    
    let rootView = SplashView()
    
    //MARK: - Life Cycle
    
    init(viewModel: SplashViewModel) {
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
    
    //MARK: - UI & Layout
    
    private func bindViewModel() {
        let input = SplashViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            exitButtonDidTapEvent: exitButtonDidTapSubject
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.presentVersionAlert
            .asDriver(onErrorJustReturn: .mustUpdate)
            .drive(with: self, onNext: { owner, version in
                let alertVC = VersionAlertViewController(version)
                alertVC.delegate = owner
                alertVC.modalPresentationStyle = .overFullScreen
                owner.present(alertVC, animated: false)
            }).disposed(by: disposeBag)
        
        output.showToast
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, message in
                owner.showToast(message)
            }).disposed(by: disposeBag)
        
        output.autoLoginFail
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: { _ in
                RootSwitcher.update(.login)
            }).disposed(by: disposeBag)
        
        output.autoLoginSuccess
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, userInfo in
                //TODO: 여기서 userInfo 처리 혹은 RootSwitcher가 처리
                RootSwitcher.update(.home)
            }).disposed(by: disposeBag)
    }
}

//MARK: - VersionAlertViewControllerDelegate

extension SplashViewController: VersionAlertViewControllerDelegate {
    
    func updateButtonDidTap(_ versionState: VersionState) {
        guard let url = URL(string: ExternalURL.zoocAppStore()) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)    
        }
    }
    
    func exitButtonDidTap() {
        exitButtonDidTapSubject.onNext(Void())
    }
}
