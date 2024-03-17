//
//  OnboardingWelcomeViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingWelcomeViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let userService: UserService
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = OnboardingWelcomeView()
    
    //MARK: - Life Cycle
    
    init(userService: UserService) {
        self.userService = userService
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
        setNavigationBar()
    }
    
    //MARK: - Custom Method
    
    func bindUI() {
        rootView.goHomeButton.rx.tap.subscribe(with: self, onNext: { owner, _ in
            owner.requestFCMTokenAPI()
        }).disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    private func requestFCMTokenAPI() {
        userService.putFCMToken(UserDefaultsManager.fcmToken)
            .subscribe(onFailure: { _ in
                print("FCM 토큰 갱신 API 확인해보세요e")
            },onDisposed: {
                let tbc = DIContainer.shared.makeTabBarController()
                UIApplication.shared.changeRootViewController(tbc)
            }
            ).disposed(by: disposeBag)
    }
}
