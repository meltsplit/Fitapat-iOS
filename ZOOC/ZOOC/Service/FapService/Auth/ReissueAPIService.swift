//
//  ReissueAPIService.swift
//  ZOOC
//
//  Created by 류희재 on 1/6/24.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

final class ReissueAPIService: Networking {
    
    private var provider = MoyaProvider<AuthTargetType>(plugins: [MoyaLoggingPlugin()])
    
    // MARK: - Custom Methods
    
    // 401 error 시 토큰 재발급 Request
    func postRefreshToken() -> Single<FitapatReissueResult> {
        provider.rx.request(.postRefreshToken)
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(FitapatReissueResult.self)
    }
}

