//
//  CustomService.swift
//  ZOOC
//
//  Created by 장석우 on 12/17/23.
//

import Foundation

import Moya
import RxMoya
import RxSwift

protocol CustomService {
    func getConcept() -> Single<[CustomConceptResult]>
    func getSampleCharacter(_ conceptID: Int) -> Single<[CharacterResult]>
    func getDetailSampleCharacter(_ characterID: Int) ->  Single<DetailSampleCharacterResult>
    
    func getCharacter() -> Single<[CustomCharacterResult]>
    func getDetailCharacter(_ characterID: Int) -> Single<DetailCharacterResult>
    
    func getRecommendKeywords(_ conceptID: Int) -> Single<RecommendKeywordsResult>
    func getRecommendKeywordsPrompts(_ conceptID: Int) -> Single<RecommendKeywordsResult>
    func postCharacter(_ request: MakeCharacterRequest) -> Single<MakeCharacterResult>
}

struct DefaultCustomService: CustomService {
    private var provider = MoyaProvider<CustomTargetType>(session: Session(interceptor: FapInterceptor.shared),
                                                          plugins: [MoyaLoggingPlugin()])
}

extension DefaultCustomService {
    
    func getConcept() -> Single<[CustomConceptResult]> {
        provider.rx.request(.getConcpet)
            .filterSuccessfulStatusCodes()
            .mapGenericResponse([CustomConceptResult].self)
    }
    
    func getSampleCharacter(_ conceptId: Int) -> Single<[CharacterResult]> {
        provider.rx.request(.getSampleCharacter(conceptId))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse([CharacterResult].self)
    }
    
    func getDetailSampleCharacter(_ characterID: Int) -> Single<DetailSampleCharacterResult> {
        provider.rx.request(.getDetailSampleCharacter(characterID))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(DetailSampleCharacterResult.self)
    }
    
    
    func getCharacter() -> Single<[CustomCharacterResult]> {
        provider.rx.request(.getCharacter)
            .filterSuccessfulStatusCodes()
            .mapGenericResponse([CustomCharacterResult].self)
    }
    
    func getDetailCharacter(_ characterID: Int) -> Single<DetailCharacterResult> {
        provider.rx.request(.getDetailCharacter(characterID))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(DetailCharacterResult.self)
    }
    
    func getRecommendKeywords(_ conceptID: Int) -> Single<RecommendKeywordsResult> {
        return Single<RecommendKeywordsResult>
            .just(.getMock())
    }
    
    //    func getRecommendPrompts(_ concept: CustomConceptMock) -> Single<RecommendKeywordPromptsResult> {
    //        return Single<RecommendKeywordPromptsResult>.just(.getMock(concept))
    //    }
    //
    //    func postKeywordsPrompt(_ petID: Int, _ request: [String: String]) -> Single<KeywordsPromptResult> {
    //        provider.rx.request(.postKeywordPrompts(petID, request))
    //    }
    
    func getRecommendKeywordsPrompts(_ conceptID: Int) -> Single<RecommendKeywordsResult> {
        provider.rx.request(.getReommedKeywordsPrompts(conceptID))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(RecommendKeywordsResult.self)
    }
    
    func postCharacter(_ request: MakeCharacterRequest) -> Single<MakeCharacterResult>{
        provider.rx.request(.postCharacter(request))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(MakeCharacterResult.self)
    }
}


struct TestCustomService: CustomService {
    func getRecommendKeywords(_ conceptID: Int) -> RxSwift.Single<RecommendKeywordsResult> {
        return Single<RecommendKeywordsResult>.just(.getMock())
    }
    
    func getSampleCharacter(_ conceptID: Int) -> RxSwift.Single<[CharacterResult]> {
        return Single<[CharacterResult]>.just([])
    }
    
    func getDetailSampleCharacter(_ characterID: Int) -> RxSwift.Single<DetailSampleCharacterResult> {
        return Single<DetailSampleCharacterResult>.just(.init(id: 1, petName: "123", image: "123", keyword: .init(outfit: nil, accessory: nil, background: nil), concept: .init(id: 1, name: "", description: "", image: "")))
    }
    
    func getDetailCharacter(_ characterID: Int) -> RxSwift.Single<DetailCharacterResult> {
        return Single<DetailCharacterResult>.just(.init(id: 1, image: "", keyword: .init(outfit: nil, accessory: nil, background: nil), concept: .init(id: 1, name: "", description: "", image: ""), hasPurchased: false, createdAt: ""))
    }
    
    func getRecommendKeywordsPrompts(_ conceptID: Int) -> RxSwift.Single<RecommendKeywordsResult> {
        return Single<RecommendKeywordsResult>.just(.getMock())
    }
    
    func postCharacter(_ request: MakeCharacterRequest) -> RxSwift.Single<MakeCharacterResult> {
        return Single<MakeCharacterResult>.just(.init(id: 1, image: "https://cdn.leonardo.ai/users/0411a1c5-ad17-4b1e-a451-915163e93773/generations/5f5fbc70-d24f-492e-a00a-9fec00168c72/AlbedoBase_XL_full_body_shot_high_detail8k_photorealistic_cute_0.jpg"))
    }
    
    func getConcept() -> Single<[CustomConceptResult]> {
        return Single<[CustomConceptResult]>
            .just(CustomConceptResult.getMock())
    }
    
    
    func getCharacter() -> Single<[CustomCharacterResult]> {
        return Single<[CustomCharacterResult]>.just([])
    }
     
}
