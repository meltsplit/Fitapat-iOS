//
//  ConceptDetailViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2/3/24.
//

import Foundation

import RxSwift
import RxRelay

final class CustomDetailViewModel: ViewModelType {
    
    //MARK: - Dependency
    
    private let usecase: CustomDetailUseCase
    
    //MARK: - Properties
    
    struct Input {
        let viewWillAppearEvent: Observable<CustomType>
        let conceptApplyButtonDidTap: Observable<Void>
        let albumBuyButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let keywordData = PublishRelay<[(CustomKeywordType, PromptDTO?)]>()
        let detailCharacterData = PublishRelay<DetailCustomEntity?>()
        let pushToSelfCustomWebVC = PublishRelay<MakeCharacterResult?>()
        let applyButtonOutput = PublishRelay<TicketState>()
    }
    
    //MARK: - Life Cycle
    
    init(usecase: CustomDetailUseCase) {
        self.usecase = usecase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent
            .subscribe(with: self, onNext: { owner, detailType in
                owner.usecase.getDetailCustomData(detailType)
            }).disposed(by: disposeBag)
        
        
        input.conceptApplyButtonDidTap
            .flatMap(usecase.checkTicketState)
            .bind(to: output.applyButtonOutput)
            .disposed(by: disposeBag)
        
        
        input.albumBuyButtonDidTap
            .withLatestFrom(usecase.detailCharacterData)
            .filter { $0 != nil }
            .map { $0! }
            .map { $0.characterData }
            .map { MakeCharacterResult(id: $0.id, image: $0.image) }
            .bind(to: output.pushToSelfCustomWebVC)
            .disposed(by: disposeBag)

        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        usecase.keywordData
            .bind(to: output.keywordData)
            .disposed(by: disposeBag)
        
        usecase.detailCharacterData
            .bind(to: output.detailCharacterData)
            .disposed(by: disposeBag)
    }
}
