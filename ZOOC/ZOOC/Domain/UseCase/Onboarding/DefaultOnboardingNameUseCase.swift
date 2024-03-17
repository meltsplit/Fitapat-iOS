//
//  OnboardingNameUseCase.swift
//  ZOOC
//
//  Created by 장석우 on 3/8/24.
//

import RxSwift
import RxRelay

final class DefaultOnboardingNameUseCase: OnboardingNameUseCase {
    
    let userRepository: UserRepository
    let authRepository: AuthRepository
    private let disposeBag = DisposeBag()
    
    let loginError = PublishRelay<String>()
    
    init(
        userRepository: UserRepository,
        authRepository: AuthRepository
    ) {
        self.userRepository = userRepository
        self.authRepository = authRepository
    }
    
}
