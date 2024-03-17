//
//  DefaultCustomUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2/2/24.
//

import RxSwift
import RxCocoa
import Foundation

final class DefaultCustomUseCase: CustomUseCase {
    
    private let customRepository: CustomRepository
    private let userRepository: UserRepository
    
    private let disposeBag = DisposeBag()
    
    //컨셉뷰
    var conceptItemData = PublishRelay<[ConceptItemEntity]>()
    var conceptData: [CustomConceptResult] = []
    var sampleCharacterData = PublishRelay<[[CharacterResult]]>()
    
    //앨범뷰
    var characterData = PublishRelay<[[String : [CustomCharacterResult]]]>()
    
    init(
        userRepository: UserRepository,
        customRepository: CustomRepository
    ) {
        self.userRepository = userRepository
        self.customRepository = customRepository
    }
}

extension DefaultCustomUseCase {
    func getCustomData() {
        getConceptData()
        getAlbumData()
    }
    
    func getConceptData() {
        customRepository.getConcept()
            .do(onNext: { [weak self] conceptData in
                self?.conceptData = conceptData
            })
            .map { $0.map { $0.id } }
            .flatMap(customRepository.getSampleCharacter)
            .subscribe(with: self, onNext: { owner, sampleCharacterList in
                var conceptItemData: [ConceptItemEntity] = []
                for index in 0..<sampleCharacterList.count {
                    let conceptItem = ConceptItemEntity(
                        conceptData: owner.conceptData[index],
                        sampleCharacterData: sampleCharacterList[index]
                    )
                    conceptItemData.append(conceptItem)
                }
                owner.conceptItemData.accept(conceptItemData)
            }).disposed(by: disposeBag)
    }
    
    func getAlbumData() {
        customRepository.getCharacter()
            .map { $0.toDomain() }
            .bind(to: characterData)
            .disposed(by: disposeBag)
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
