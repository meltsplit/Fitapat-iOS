//
//  AuthServide.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/05.
//

import Foundation

import Moya
import RxMoya
import RxSwift

protocol AuthService {
    func userCheck(_ accessToken: String, _ providerType: String) -> Single<UserInfoResult>
    func login(_ accessToken: String,
               _ providerType: String) -> Single<FitapatAuthenticationResult>
    func signUp(_ providerType: String,
                _ accessToken: String,
                _ request: UserInfoRequest
    ) -> Single<FitapatAuthenticationResult>
}

struct DefaultAuthService {  //TODO: struct로 해도 되나? class 말고 struct로 했을 때 부작용 뭐가 있지
    private var provider = MoyaProvider<AuthTargetType>(session: Session(interceptor: FapInterceptor.shared),
                                                        plugins: [MoyaLoggingPlugin()])
}

extension DefaultAuthService: AuthService {
    func userCheck(_ accessToken: String, _ providerType: String) -> Single<UserInfoResult> {
        provider.rx.request(.getUserCheck(accessToken, providerType))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(UserInfoResult.self)
    }
    
    func login(_ accessToken: String, _ providerType: String) -> Single<FitapatAuthenticationResult> {
        provider.rx.request(.login(accessToken, providerType))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(FitapatAuthenticationResult.self)
    }
    
    func signUp(_ providerType: String,
                _ accessToken: String,
                _ request: UserInfoRequest
    ) -> Single<FitapatAuthenticationResult> {
        guard let encodedData = try? JSONEncoder().encode(request)
        else { return Single<FitapatAuthenticationResult>.error(AuthError.encodedFail) }
        return provider.rx.request(.signUp(providerType,
                                           accessToken,
                                           encodedData))
        .filterSuccessfulStatusCodes()
        .mapGenericResponse(FitapatAuthenticationResult.self)
    }
}


