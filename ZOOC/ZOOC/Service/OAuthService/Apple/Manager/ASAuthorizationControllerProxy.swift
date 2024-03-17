//
//  ASAuthorizationControllerProxy.swift
//  ZOOC
//
//  Created by 류희재 on 1/5/24.
//

import UIKit

import AuthenticationServices
import RxCocoa
import RxSwift

extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

class ASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var presentationWindow: UIWindow = UIWindow()

    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }

    // MARK: DelegateProxyType
    public static func registerKnownImplementations() {
        register { ASAuthorizationControllerProxy(controller: $0) }
    }

    // MARK: Proxy Subject
    lazy var didComplete = PublishSubject<ASAuthorization>()

    // MARK: ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        didComplete.onCompleted()
    }

    // MARK: ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow
    }

    // MARK: Completed
    deinit {
        self.didComplete.onCompleted()
    }
}

