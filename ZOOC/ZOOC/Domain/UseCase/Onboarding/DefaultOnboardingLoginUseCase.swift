//
//  DefaultOnboardingLoginUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/10/05.
//

import RxSwift
import RxCocoa
import Moya
import Foundation

final class DefaultOnboardingLoginUseCase: OnboardingLoginUseCase {
    
    private let disposeBag = DisposeBag()
    let authRepository: AuthRepository
    let userRepository: UserRepository
    
    init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    var loginError = PublishRelay<String>()
    
    func userCheck(_ serviceType: OAuthProviderType) -> Observable<OnboardingUserInfo> {
        authRepository
            .authorize(serviceType)
            .flatMap(authRepository.userCheck)
            .catch { _ in
                self.loginError.accept("잠시 후 다시시도 해주세요")
                return Observable.empty()
            }
    }
}
