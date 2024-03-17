//
//  DefaultSplashUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 1/16/24.
//

import RxSwift
import RxCocoa

final class DefaultSplashUseCase: SplashUseCase {
    
    private let userRepository: UserRepository
    private let appRepository: AppRepository
    private let reissueService: ReissueAPIService
    
    private let disposeBag = DisposeBag()
    
    var autoLoginFail = PublishRelay<Void>()
    
    init(
        userRepository: UserRepository,
        appRepository: AppRepository,
        reissueService: ReissueAPIService
    ) {
        self.userRepository = userRepository
        self.appRepository = appRepository
        self.reissueService = reissueService
    }
    
    func checkVersion() -> Observable<VersionState> {
        appRepository.checkVersion().asObservable()
            .catch { _ in Observable.just(.mustUpdate) }
    }
    
    func autoLogin() -> Observable<Void> {
        Observable.just(UserDefaultsManager.zoocAccessToken)
            .do(onNext: { if $0.isEmpty { self.autoLoginFail.accept(()) } })
            .filter { !$0.isEmpty }
            .map { _ in }
            .flatMap(reissueService.postRefreshToken().asObservable)
            .do(onNext: { result in
                UserDefaultsManager.zoocAccessToken = result.accessToken 
                UserDefaultsManager.zoocRefreshToken = result.refreshToken
            })
            .map {_ in }
            .flatMap(userRepository.updateFCMToken)
            .flatMap(DefaultPetRepository.shared.getPet)
            .map { _ in }
            .catch { error in
                if error as? PetError == .noPet { return Observable.just(()) }
                self.autoLoginFail.accept(())
                return Observable.empty()
            }
        
    }
}
