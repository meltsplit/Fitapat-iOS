//
//  CustomRepository.swift
//  ZOOC
//
//  Created by 장석우 on 12/17/23.
//

import Foundation

import RxSwift
import RxRelay

protocol CustomRepository {
    func getConcept() -> Observable<[CustomConceptResult]>
    func getSampleCharacter(_ conceptIDList: [Int]) -> Observable<[[CharacterResult]]>
    func getDetailSampleCharacter(_ characterID: Int) -> Observable<DetailCustomEntity>
    
    func getCharacter() -> Observable<[CustomCharacterResult]>
    func getDetailCharacter(_ characterID: Int) -> Observable<DetailCustomEntity>
    
    
    func getRecommendKeywordsPrompts(_ conceptID: Int) -> Observable<[CustomKeywordType: [RecommendKeywordResult]]>
    func makeCharacter(conceptID: Int, keywordsprompts: [CustomKeywordType: PromptDTO?]) -> Observable<MakeCharacterResult>
}

final class DefaultCustomRepository: CustomRepository {

    //MARK: - Dependency
    
    private let customService: CustomService
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    init(customService: CustomService) {
        self.customService = customService
    }
    
    //MARK: - Methods
     
    func getConcept() -> Observable<[CustomConceptResult]> {
        customService.getConcept().asObservable()
    }
    
    func getSampleCharacter(_ conceptIDList: [Int]) -> Observable<[[CharacterResult]]> {
        return Observable.deferred {
                let observables: [Observable<[CharacterResult]>] = conceptIDList.map { conceptID in
                    return self.customService.getSampleCharacter(conceptID).asObservable()
                }
                return Observable.zip(observables)
            }
    }
    
    func getDetailSampleCharacter(_ characterID: Int) -> Observable<DetailCustomEntity> {
        customService.getDetailSampleCharacter(characterID)
            .map { $0.toEntity() }
            .asObservable()
    }
    
    func getCharacter() -> Observable<[CustomCharacterResult]> {
        customService.getCharacter().asObservable()
    }
    
    func getDetailCharacter(_ characterID: Int) -> Observable<DetailCustomEntity> {
        customService.getDetailCharacter(characterID)
            .map { $0.toEntity() }
            .asObservable()
    }
    
    func getRecommendKeywordsPrompts(_ conceptID: Int) -> Observable<[CustomKeywordType: [RecommendKeywordResult]]> {
        customService.getRecommendKeywordsPrompts(conceptID)
            .map { $0.toEntity() }
            .asObservable()
    }
    
    func makeCharacter(conceptID: Int, keywordsprompts: [CustomKeywordType : PromptDTO?]) -> Observable<MakeCharacterResult> {
        
        let accRequest = keywordsprompts[.accesorry] ?? nil
        let bgRequest = keywordsprompts[.background] ?? nil
        let outfitRequest = keywordsprompts[.outfit] ?? nil
        
        let promptsRequests = PromptsRequest(background: bgRequest, outfit: outfitRequest, accessory: accRequest)
        let request = MakeCharacterRequest(conceptId: conceptID, keyword: promptsRequests)
        return customService.postCharacter(request).asObservable()
    }
}


