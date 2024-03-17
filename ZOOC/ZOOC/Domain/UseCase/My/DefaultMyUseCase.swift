//
//  DefaultMyUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyUseCase: MyUseCase {
    private let petRepository: PetRepository
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    private let disposeBag = DisposeBag()
    
    init(
        petRepository: PetRepository,
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.petRepository = petRepository
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    var profileData = PublishRelay<PetResult>()
    var logoutSuccess = PublishRelay<Bool>()
    var deleteAccountSuccess = PublishRelay<Bool>()
}

extension DefaultMyUseCase {
    func requestMyPage() {
        petRepository.getPet()
            .subscribe(with: self, onNext: { owner, pet in
                owner.profileData.accept(pet)
            }).disposed(by: disposeBag)
    }
    
    func logout() {
        userRepository.logout()
            .subscribe(with: self, onNext: { owner, _ in
                owner.logoutSuccess.accept(true)
            }).disposed(by: disposeBag)
    }
    
    func deleteAccount() {
        userRepository.deleteAccount()
            .subscribe(with: self, onNext: { owner, isDeleted in
                owner.deleteAccountSuccess.accept(isDeleted)
            }).disposed(by: disposeBag)
    }
}



