//
//  OnboardingUsecase.swift
//  ZOOC
//
//  Created by 장석우 on 3/8/24.
//

import RxSwift
import RxRelay

protocol OnboardingBaseUseCase {
    var authRepository: AuthRepository { get }
    var userRepository: UserRepository { get }
    var loginError: PublishRelay<String> { get}
    
    func login(_ model: OnboardingUserInfo) -> Observable<Void>
    func signUp(_ model: OnboardingUserInfo) -> Observable<Void>
    func loginWithUserInfo(_ model: OnboardingUserInfo) -> Observable<Void>
}

extension OnboardingBaseUseCase {
    
    func signUp(_ model: OnboardingUserInfo) -> Observable<Void> {
        authRepository
            .signUp(model)
            .flatMap{ _ in login(model)}
    }
    
    func login(_ model: OnboardingUserInfo) -> Observable<Void> {
        authRepository
            .login(model.oauthModel)
            .do(onNext: authRepository.saveJWTTokens)
            .map { _ in }
            .flatMap(userRepository.updateFCMToken)
            .flatMap(DefaultPetRepository.shared.getPet)
            .map { _ in }
            .do(onError: { error in
                switch error as? AuthError {
                case .kakaoLoginError: loginError.accept("카카오 계정 인증에 문제가 생겼습니다")
                case .appleLoginError: loginError.accept("애플 계정 인증에 문제가 생겼습니다")
                default: loginError.accept("로그인에 문제가 생겼습니다. 잠시 후 시도해주세요")
                }
            }).catch { error in
                guard error as? PetError == PetError.noPet else  { return Observable.empty()}
                return Observable.just(())
            }
    }
    
    func loginWithUserInfo(_ model: OnboardingUserInfo) -> Observable<Void> {
        authRepository.login(model.oauthModel)
            .do(onNext: authRepository.saveJWTTokens)
            .map { _ in model.userInfo.toData() }
            .flatMap(userRepository.updateUser)
            .flatMap(userRepository.updateFCMToken)
            .flatMap(DefaultPetRepository.shared.getPet)
            .map { _ in }
            .do(onError: { error in
                switch error as? AuthError {
                case .kakaoLoginError: loginError.accept("카카오 계정 인증에 문제가 생겼습니다")
                case .appleLoginError: loginError.accept("애플 계정 인증에 문제가 생겼습니다")
                default: loginError.accept("로그인에 문제가 생겼습니다. 잠시 후 시도해주세요")
                }
            }).catch { error in
                guard error as? PetError == PetError.noPet else  { return Observable.empty()}
                return Observable.just(())
            }
    }
}
