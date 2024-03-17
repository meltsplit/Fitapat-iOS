//
//  SimpleEasyNotificationService.swift
//  ZOOC
//
//  Created by 장석우 on 3/6/24.
//

import Foundation

import RxSwift
import Moya
import RxMoya


protocol SimpleEasyNotificationService {
    func sendMessage(_ request: SimpleEasyNotificationRequest) -> Single<Void>
}

struct DefaultSimpleEasyNotificationService: SimpleEasyNotificationService {
    
    private var provider = MoyaProvider<SENTargetType>(plugins: [MoyaLoggingPlugin()])
    
    func sendMessage(_ request: SimpleEasyNotificationRequest) -> Single<Void> {
        provider.rx.request(.sendMessage(request))
            .filterSuccessfulStatusCodes()
            .map { _ in ()}
    }
}
