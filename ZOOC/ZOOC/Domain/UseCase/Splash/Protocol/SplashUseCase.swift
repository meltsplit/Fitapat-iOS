//
//  SplashUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 1/15/24.
//

import RxSwift
import RxCocoa

protocol SplashUseCase {
    
    var autoLoginFail: PublishRelay<Void> { get }
    
    func checkVersion() -> Observable<VersionState> 
    func autoLogin() -> Observable<Void>
}
