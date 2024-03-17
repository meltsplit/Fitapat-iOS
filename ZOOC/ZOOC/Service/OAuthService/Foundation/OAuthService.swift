//
//  OAuthService.swift
//  ZOOC
//
//  Created by 류희재 on 1/8/24.
//

import RxSwift

final class OAuthService {
    
    private let oAuthService: OAuthServiceType
    
    init(oAuthService: OAuthServiceType) {
        self.oAuthService = oAuthService
    }
    
    func authorize() -> Single<OAuthAuthenticationModel> {
        return oAuthService.authorize()
    }
}
