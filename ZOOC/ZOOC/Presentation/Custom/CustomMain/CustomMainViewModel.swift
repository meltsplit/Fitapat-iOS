//
//  CustomSelectKeywordViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 12/16/23.
//

import Foundation

import RxSwift
import RxRelay

import Moya

final class CustomMainViewModel: ViewModelType {
    
    //MARK: - Dependency
    
    private var petRepository: PetRepository
    private var customRepository: CustomRepository
    
    //MARK: - Properties
    
    private let concept: CustomConceptResult
    private var currentKeywordsPrompt: [CustomKeywordType : PromptDTO?] =
    [
        .accesorry : nil,
        .background : nil,
        .outfit : nil
    ]
    
    private var recommendKeywordsPrompts: [CustomKeywordType: [RecommendKeywordResult]] = [:]
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let keywordPromptCellDidTapEvent: Observable<CustomKeywordType>
        let recommendPromptCellDidTapEvent: Observable<(CustomKeywordType, RecommendKeywordResult)>
        let resetKeywordButtonDidTapEvent: Observable<Void>
        let doneButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        let backgroundImageData = PublishRelay<String>()
        let currentKeywordsPromptData = PublishRelay<(CustomKeywordType, PromptDTO?)>()
        let recommendPromptsData = PublishRelay<[(CustomKeywordType, RecommendKeywordResult)]>()
        let showPromptEditView = PublishRelay<CustomKeywordType>()
        let notEnoughTicket = PublishRelay<Void>()
        let change을를 = PublishRelay<String>()
        let showToast = PublishRelay<String>()
        let showLoading = PublishRelay<Bool>()
        let pushCustomVirtualResultVC = PublishRelay<MakeCharacterResult>()
    }
    
    //MARK: - Life Cycle
    
    init(
        petRepository: PetRepository,
        customRepository: CustomRepository,
        concept: CustomConceptResult,
        keywordsPrompt: [CustomKeywordType : PromptDTO?]?
    ) {
        self.petRepository = petRepository
        self.customRepository = customRepository
        self.concept = concept
        if let keywordsPrompt {
            self.currentKeywordsPrompt = keywordsPrompt
        }
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .map { self.currentKeywordsPrompt }
            .subscribe(with: self, onNext: { owner, keywordsprompt in
                keywordsprompt.forEach {
                    output.currentKeywordsPromptData.accept($0)
                    if $0.key == .outfit,
                       let prompt = $0.value?.keywordKo  {
                        let 을or를 = Syllable.is받침(prompt) ? 조사.을를.받침있을때 : 조사.을를.받침없을때
                        output.change을를.accept(을or를)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .map { self.concept.id }
            .flatMap(customRepository.getRecommendKeywordsPrompts)
            .subscribe(with: self, onNext: { owner, prompts in
                owner.recommendKeywordsPrompts = prompts
            })
            .disposed(by: disposeBag)
        
        input.viewDidLoadEvent
            .map { self.concept.image }
            .bind(to: output.backgroundImageData)
            .disposed(by: disposeBag)
        
        
        input.keywordPromptCellDidTapEvent
            .map { [weak  self] type in
                let prompts = self?.recommendKeywordsPrompts[type] ?? []
                return prompts.map { (type, $0) }
            }
            .bind(to: output.recommendPromptsData)
            .disposed(by: disposeBag)
        
        input.keywordPromptCellDidTapEvent
            .bind(to: output.showPromptEditView)
            .disposed(by: disposeBag)

        input.recommendPromptCellDidTapEvent
            .do(onNext: {
                print($0.1.keywordKo)
                if $0.0 == .outfit {
                    let 을or를 = Syllable.is받침($0.1.keywordKo) ? 조사.을를.받침있을때 : 조사.을를.받침없을때
                    output.change을를.accept(을or를)
                }
            })
            .do(onNext: {
                self.currentKeywordsPrompt[$0.0] = $0.1.toPromptDTO()
            })
            .map{ ($0.0, $0.1.toPromptDTO())}
            .bind(to: output.currentKeywordsPromptData)
            .disposed(by: disposeBag)
        
        input.resetKeywordButtonDidTapEvent
            .withLatestFrom(input.keywordPromptCellDidTapEvent)
            .do(onNext: {
                if $0 == .outfit { output.change을를.accept("을") }
            })
            .do(onNext: { self.currentKeywordsPrompt[$0] = nil })
            .map{ ($0, nil)}
            .bind(to: output.currentKeywordsPromptData)
            .disposed(by: disposeBag)
            
        input.doneButtonDidTapEvent
            .map { self.currentKeywordsPrompt }
            .flatMap({ [weak self] data -> Observable<MakeCharacterResult> in
                guard let self else { return .empty()}
                output.showLoading.accept(true)
                var keywordsprompts = data
                let bgPrompts = data[.background] ?? nil
                if bgPrompts == nil {
                    let defaultBG = self.recommendKeywordsPrompts[.background]?.first
                    keywordsprompts[.background] = defaultBG?.toPromptDTO()
                }
                return makeCharacterUsecase(conceptID: concept.id,
                                            keywordsprompts: keywordsprompts,
                                            output: output)
            })
            .bind(to: output.pushCustomVirtualResultVC)
            .disposed(by: disposeBag)
        
        return output
    }
    
}


extension CustomMainViewModel {
    private func makeCharacterUsecase(
        conceptID: Int,
        keywordsprompts: [CustomKeywordType : PromptDTO?], 
        output: Output) -> Observable<MakeCharacterResult> {
            return customRepository.makeCharacter(conceptID: self.concept.id,
                                                       keywordsprompts: keywordsprompts)
                .do(onNext: { _ in output.showLoading.accept(false) },
                    onError: { error in
                    if let err = error as? MoyaError,
                       err.response?.statusCode == 400,
                       let data = err.response?.data,
                       let decodedData = try? JSONDecoder().decode(SimpleResponse.self, from: data),
                       decodedData.status == 4004 {
                        output.showLoading.accept(false)
                        output.notEnoughTicket.accept(())
                    }
                    else {
                        output.showLoading.accept(false)
                    }
                },
                    onCompleted: { output.showLoading.accept(false) }
                ).catch { _ in Observable.empty() }
    }
}
