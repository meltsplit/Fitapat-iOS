//
//  UserService.swift
//  ZOOC
//
//  Created by 류희재 on 1/12/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

protocol UserService {
    func putFCMToken(_ fcmToken: String) -> Single<SimpleResponse>
    func patchUser(_ request: UserInfoRequest) -> Single<SimpleResponse>
    func getTicket() -> Single<Int>
    func logout() -> Single<Bool>
    func deleteAccount() -> Single<Bool>
}

struct DefaultUserService {  //TODO: struct로 해도 되나? class 말고 struct로 했을 때 부작용 뭐가 있지
    private var provider = MoyaProvider<UserTargetType>(session: Session(interceptor: FapInterceptor.shared),
                                                        plugins: [MoyaLoggingPlugin()])
}

extension DefaultUserService: UserService {
    func putFCMToken(_ fcmToken: String) -> Single<SimpleResponse> {
        provider.rx.request(.patchFCMToken(fcmToken))
            .filterSuccessfulStatusCodes()
            .map(SimpleResponse.self)
    }
    
    func patchUser(_ request: UserInfoRequest) -> Single<SimpleResponse> {
        provider.rx.request(.patchUser(request))
            .filterSuccessfulStatusCodes()
            .map(SimpleResponse.self)
    }
    
    func getTicket() -> Single<Int> {
        provider.rx.request(.getTicket)
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(Int.self)
    }
    
    func logout() -> Single<Bool> {
        provider.rx.request(.logout)
            .filterSuccessfulStatusCodes()
            .map { _ in true }
    }
    
    func deleteAccount() -> Single<Bool> {
        provider.rx.request(.deleteAccount)
            .filterSuccessfulStatusCodes()
            .map { _ in true }
    }
}



