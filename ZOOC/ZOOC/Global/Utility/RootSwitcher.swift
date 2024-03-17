//
//  RootSwitcher.swift
//  ZOOC
//
//  Created by 류희재 on 1/15/24.
//

import UIKit
import RxSwift

final class RootSwitcher {
    enum Destination {
        case splash(_ userInfo: UserInfoDict?)
        case login
        case home
        case custom(UIViewController)
    }

    static func update(_ destination: Destination) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {
            return
        }
        switch destination {
        case .splash(let userInfo):
            delegate.window?.rootViewController =
            UINavigationController(rootViewController: DIContainer.shared.makeSplashVC(userInfo))
        case .login:
            delegate.window?.rootViewController = 
            UINavigationController(rootViewController: DIContainer.shared.makeLoginVC())
        case .home:
            let tabVC = DIContainer.shared.makeTabBarController()
            delegate.window?.rootViewController = tabVC
        case let .custom(viewController):
            delegate.window?.rootViewController = UINavigationController(rootViewController: viewController)
        }
    }
}
