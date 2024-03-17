//
//  BaseViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - Properties
    
    var isPopGestureEnabled: Bool = true // default는 pop 제스처 가능하게
    var isNavigationBarHidden: Bool = false // default는 NavigationBar 보이게
    
    //MARK: - UI Components
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = isPopGestureEnabled
        if isPopGestureEnabled {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Public Method
    
    func setNavigationBar(
        isNavigationBarHidden: Bool,
        isPopGestureEnabled: Bool
    ) {
        self.isNavigationBarHidden = isNavigationBarHidden
        self.isPopGestureEnabled = isPopGestureEnabled
    }
    
    //MARK: - Private Method
    
    private func setUI(){
        view.backgroundColor = .zw_background
    }
    
   
    @objc private func popToRoot() {
        let onboardingNVC = UINavigationController(
            rootViewController: DIContainer.shared.makeLoginVC()
        )
        UIApplication.shared.changeRootViewController(onboardingNVC)
    }
    
    func navigationOnboarding(_ data: (OnboardingDestination, OnboardingStateManager, OnboardingUserInfo)) {
        let destination = data.0
        let manager = data.1
        let entity = data.2
        switch destination {
        case .agreement:
            let vc = DIContainer.shared.makeAgreementVC(manager, entity)
            navigationController?.pushViewController(vc, animated: true)
        case .name:
            let vc = DIContainer.shared.makeNameVC(manager, entity)
            navigationController?.pushViewController(vc, animated: true)
        case .phone:
            let vc = DIContainer.shared.makePhoneVerificationVC(manager, entity)
            navigationController?.pushViewController(vc, animated: true)
        case .welcome:
            let vc = OnboardingWelcomeViewController(userService: DefaultUserService())
            vc.isNavigationBarHidden = true
            vc.isPopGestureEnabled = false
            navigationController?.pushViewController(vc, animated: true)
        case .main:
            RootSwitcher.update(.home)
        case .unknown:
            showToast("온보딩 오류가 발생했습니다")
            RootSwitcher.update(.login)
        }
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController else { return false }
        return navigationController.viewControllers.count > 1
    }
}
