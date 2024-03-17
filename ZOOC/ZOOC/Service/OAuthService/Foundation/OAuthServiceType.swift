//
//  OAuthServiceType.swift
//  ZOOC
//
//  Created by 류희재 on 1/8/24.
//

import RxSwift

protocol OAuthServiceType {
    func authorize() -> Single<OAuthAuthenticationModel>
}
