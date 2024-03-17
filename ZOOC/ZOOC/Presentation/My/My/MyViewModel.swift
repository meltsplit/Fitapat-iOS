//
//  MyViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/04.
//

import UIKit

import RxSwift
import RxCocoa

final class MyViewModel: ViewModelType {
    private let myUseCase: MyUseCase
    
    init(myUseCase: MyUseCase) {
        self.myUseCase = myUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let logoutButtonDidTapEvent: Observable<IndexPath>
        let deleteAccountButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var profileData = PublishRelay<PetResult>()
        var logoutSuccess = PublishRelay<Bool>()
        var deleteAccountSuccess = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myUseCase.requestMyPage()
        }).disposed(by: disposeBag)
        
        input.logoutButtonDidTapEvent.subscribe(with: self, onNext: { owner, index in
            owner.myUseCase.logout()
        }).disposed(by: disposeBag)
        
        input.deleteAccountButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myUseCase.deleteAccount()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        myUseCase.profileData
            .bind(to: output.profileData)
            .disposed(by: disposeBag)
        
        myUseCase.logoutSuccess
            .bind(to: output.logoutSuccess)
            .disposed(by: disposeBag)
        
        myUseCase.deleteAccountSuccess
            .bind(to: output.deleteAccountSuccess)
            .disposed(by: disposeBag)
    }
}
