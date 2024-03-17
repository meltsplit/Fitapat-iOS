//
//  OAuthKakaoService.swift
//  ZOOC
//
//  Created by 장석우 on 12/19/23.
//

import Foundation

import RxSwift
import RxCocoa

import RxKakaoSDKAuth
import RxKakaoSDKUser

import KakaoSDKAuth
import KakaoSDKUser

final class OAuthKakaoService: OAuthServiceType {
    
    let disposeBag = DisposeBag()
    
    func authorize() -> Single<OAuthAuthenticationModel> {
        return login().map { OAuthAuthenticationModel(oauthType: .kakao, oauthToken: $0.accessToken) }
    }
    
    func login() -> Single<OAuthToken> {
        let isKakaoTalkLoginAvailable = UserApi.isKakaoTalkLoginAvailable()
        
        return Single.create { observer in
            if isKakaoTalkLoginAvailable {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { oAuthToken in
                        observer(.success(oAuthToken))
                    }, onError: { error in
                        observer(.failure(AuthError.kakaoLoginError))
                    })
                    .disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { oAuthToken in
                        observer(.success(oAuthToken))
                    }, onError: { error in
                        observer(.failure(AuthError.kakaoLoginError))
                    })
                    .disposed(by: self.disposeBag)
            }
            
            return Disposables.create()
        }
    }
    
    deinit {
        print("죽음")
    }
}
