//
//  OAuthAppleService.swift
//  ZOOC
//
//  Created by 류희재 on 12/19/23.
//

import UIKit

import AuthenticationServices
import RxSwift

final class OAuthAppleService: OAuthServiceType  {
    
    func authorize() -> Single<OAuthAuthenticationModel> {
        return login().map { OAuthAuthenticationModel(oauthType: .apple, oauthToken: $0!) }
    }
    
    private let disposeBag = DisposeBag()
    private let appleLoginManager = AppleLoginManager()
    
    internal func login() -> Single<String?> {
        return Single.create { observer in
            self.appleLoginManager
                .handleAuthorizationAppleIDButtonPress()
                .subscribe(onNext: { result in
                    guard
                        let auth = result.credential as? ASAuthorizationAppleIDCredential,
                        let idToken = auth.identityToken
                    else { return }
                    
                    let idTokenString = String(data: idToken, encoding: .utf8)
                    observer(.success(idTokenString))
                }, onError: { error in
                    observer(.failure(AuthError.appleLoginError))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
