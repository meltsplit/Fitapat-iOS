//
//  Intercepter.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/05.
//

import Foundation

import UIKit
import Alamofire
import Moya
import RxSwift

import Sentry


///// 토큰 만료 시 자동으로 refresh를 위한 서버 통신
final class FapInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()
    
    static let shared = FapInterceptor()
    
    private let reissueService: ReissueAPIService
    
    private init() {
        self.reissueService = ReissueAPIService()
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        let headersKey = urlRequest.allHTTPHeaderFields?.keys
        let url = urlRequest.url
        let notUseZoocAccessTokenList =
        [
            URL(string: Config.baseURL + URLs.userCheck + "?provider=apple"),
            URL(string: Config.baseURL + URLs.userCheck + "?provider=kakao"),
            URL(string: Config.baseURL + URLs.signin + "?provider=apple"),
            URL(string: Config.baseURL + URLs.signin + "?provider=kakao"),
            URL(string: Config.baseURL + URLs.signUp + "?provider=apple"),
            URL(string: Config.baseURL + URLs.signUp + "?provider=kakao")
        ]
        
        guard headersKey != APIConstants.noTokenHeader.keys
               && !notUseZoocAccessTokenList.contains(url)
        else {
            print("🦫ZoocAccessToken을 사용하지 않는 API입니다. Adapt를 수행하지 않습니다.")
            completion(.success(urlRequest))
            return
        }
        
        print("🦫 Header값을 'UserDefaultsManager.zoocAccessToken'으로 Adapt를 수행합니다!")
        var request = urlRequest
        request.setValue(UserDefaultsManager.zoocAccessToken, forHTTPHeaderField: APIConstants.auth)
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("👽 BaseTargetType의 ValidationType에 막혔습니다.")
        print("👽 API: \(request)")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401
        else {
            print("retry를 하지 않습니다.")
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("👽 Retry함수에서 가드문을 통과했습니다. 이는 서버로부터 401을 반환된 것을 의미합니다.")
        print("👽 AccessToken이 만료되었으니 refreshAPI를 호출합니다.")
        
        reissueService.postRefreshToken()
            .subscribe(with: self, onSuccess: { owner, result in
                UserDefaultsManager.zoocAccessToken = result.accessToken
                UserDefaultsManager.zoocRefreshToken = result.refreshToken
                
                completion(.retry) // 401을 받은 API를 재호출합니다.
            }, onFailure: { owner, error in
                if case let MoyaError.statusCode(response) = error {
                    if response.statusCode == 406 {
                        UserDefaultsManager.zoocAccessToken = ""
                        UserDefaultsManager.zoocRefreshToken = ""
                        owner.handlingAuthorizationFail()
                        completion(.doNotRetry)
                    }
                } else {
                    SentrySDK.capture(error: error)
                    completion(.doNotRetryWithError(error))
                }
            }).disposed(by: disposeBag)
    }
    
}

extension FapInterceptor {
    func handlingAuthorizationFail()  {
        print("👽 AccessToken 갱신에 성공했습니다! \n 401을 받은 API를 재호출합니다❗️")
        
        _Concurrency.Task {
//            await DefaultRealmService().deleteAllCartedProducts()
        }
        
        UserDefaultsManager.reset()
        DefaultPetRepository.shared.reset()
        ImageUploadManager.shared.reset()
        RootSwitcher.update(.login)
    }
}

