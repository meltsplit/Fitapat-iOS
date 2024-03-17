//
//  DefaultCustomDetailUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2/5/24.
//

import Foundation

import RxSwift
import RxRelay

final class DefaultCustomDetailUseCase: CustomDetailUseCase {
    
    private var characterID: Int
    private var customRepository: CustomRepository
    private var userRepository: UserRepository
    
    
    private let disposeBag = DisposeBag()
    
    var keywordData = PublishRelay<[(CustomKeywordType, PromptDTO?)]>()
    var detailCharacterData = BehaviorRelay<DetailCustomEntity?>(value: nil)
    
    init(
        characterID: Int,
        customRepository: CustomRepository,
        userRepository: UserRepository
    ) {
        self.characterID = characterID
        self.customRepository = customRepository
        self.userRepository = userRepository
    }
}

extension DefaultCustomDetailUseCase {
    func getDetailCustomData(_ detailType: CustomType) {
        switch detailType {
        case .concept:
            customRepository.getDetailSampleCharacter(characterID)
                .subscribe(with: self, onNext: { owner, data in
                    owner.keywordData.accept(data.keywordData)
                    owner.detailCharacterData.accept(data)
                }).disposed(by: disposeBag)
        case .character:
            customRepository.getDetailCharacter(characterID)
                .subscribe(with: self, onNext: { owner, data in
                    owner.keywordData.accept(data.keywordData)
                    owner.detailCharacterData.accept(data)
                }).disposed(by: disposeBag)
            
        }
    }
    
    func checkTicketState() -> Observable<TicketState> {
        return Observable<TicketState>.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            self.customRepository.getCharacter()
                .do(onNext: { characters in
                    if characters.isEmpty {
                        observer.onNext(.first)
                        observer.onCompleted()
                    }
                })
                .map { _ in }
                .flatMap(self.userRepository.getTicket)
                .subscribe(onNext: { numberOfTicket in
                    if numberOfTicket > 0 {
                        observer.onNext(.normal)
                        observer.onCompleted()
                    } else {
                        observer.onNext(.notEnough)
                        observer.onCompleted()
                    }
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }

}
