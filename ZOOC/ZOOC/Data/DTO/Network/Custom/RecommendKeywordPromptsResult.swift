//
//  RecommendKeywordPrompt.swift
//  ZOOC
//
//  Created by 장석우 on 12/17/23.
//

import Foundation

struct RecommendKeywordsResult: Decodable {
    let outfit: [RecommendKeywordResult]
    let accessory: [RecommendKeywordResult]
    let background: [RecommendKeywordResult]
}

struct RecommendKeywordResult: Decodable {
    let id: Int
    let keywordKo: String
    let keywordEn: String
    let image: String
}

extension RecommendKeywordsResult {
    
    func toEntity() -> [CustomKeywordType: [RecommendKeywordResult]] {
        var dict: [CustomKeywordType: [RecommendKeywordResult]] = [:]
        
        dict[.outfit] = outfit
        dict[.accesorry] = accessory
        dict[.background] = background
        
        return dict
    }
    
    static func getMock() -> RecommendKeywordsResult {
        return RecommendKeywordsResult(
            outfit: [
                .init(id: 1, keywordKo: "파란색 후드 패딩", keywordEn: "Blue Hoddie", image: "tmp"),
            ],
            accessory: [
                .init(id: 1, keywordKo: "파란색 후드 패딩", keywordEn: "Blue Hoddie", image: "tmp"),
            ],
            background: [
                .init(id: 1, keywordKo: "파란색 후드 패딩", keywordEn: "Blue Hoddie", image: "tmp"),
            ])
    }
}

extension RecommendKeywordResult {
    func toPromptDTO() -> PromptDTO {
        return .init(keywordKo: keywordKo, keywordEn: keywordEn)
    }
}

//
//    .init(id: 1, keyword: "스키장", image: "tmp"),
//    .init(id: 2, keyword: "눈 덮인 오두막집", image: "tmp"),
//    .init(id: 3, keyword: "눈 내리는 바다", image: "tmp"),
//    .init(id: 4, keyword: "Gryffindor School", image: "tmp"),
//    .init(id: 5, keyword: "겨울 삿포로", image: "tmp"),
//    .init(id: 5, keyword: "히말라야 산 정상", image: "tmp"),
//    .init(id: 4, keyword: "Gryffindor School", image: "tmp"),
//    .init(id: 5, keyword: "겨울 삿포로", image: "tmp"),
//    .init(id: 5, keyword: "히말라야 산 정상", image: "tmp"),
//
//struct RecommendKeywordPromptsResult: Decodable {
//    let data: [RecommendPromptResult]
//}
//
//struct RecommendPromptResult: Decodable {
//    var type: String
//    var prompt: [String]
//}
//
//extension RecommendKeywordPromptsResult {
//    
//    func toEntity() -> [CustomKeywordType: [RecommendKeywordPromptEntity]] {
//        var dict: [CustomKeywordType: [RecommendKeywordPromptEntity]] = [:]
//        
//        data.forEach {
//            guard let type = CustomKeywordType(rawValue: $0.type) else { return }
////            dict[type] = $0.prompt.map { RecommendKeywordPromptEntity(type: type, prompt: $0)}
//        }
//        
//        return dict
//    }
//    
//    static func getMock(_ concept: CustomConceptMock) -> RecommendKeywordPromptsResult {
//        
//        var result: [RecommendPromptResult]
//        
//        switch concept {
//        case .magic:
//            result = [RecommendPromptResult(type: "acc",
//                                            prompt: ["sitting on a magic book",
//                                                     "a lamp is sitting on the floor",
//                                                     "wearing sharp-pointed magic Hat",
//                                                     "Harry Potter glasses"]),
//                      RecommendPromptResult(type: "background",
//                                            prompt: ["mountain with full moon",
//                                                     "magic lantern",
//                                                     "Hogwarts library",
//                                                     "a lightning skies",
//                                                     "a secret train station",
//                                                     "a spooky castle",
//                                                     "red lily camp, pink sky, big moon, landscape, white butterflies"]),
//                      RecommendPromptResult(type: "outfit",
//                                            prompt: ["Gryffindor uniform",
//                                                     "Slytherin uniform",
//                                                     "magic cloak",
//                                                     "witch clothes",
//                                                     "Ravenclaw uniform",
//                                                     "wizard school yellow uniform, adorned yellow wizard's hat,"])]
//        case .winter:
//            result = [RecommendPromptResult(type: "acc",
//                                            prompt: ["with sleigh",
//                                                     "wearing fur hat",
//                                                     "wearing santa hat",
//                                                     "carrying snow board",
//                                                     "wearing muffler",
//                                                     "wearing goggles"]),
//                      RecommendPromptResult(type: "background",
//                                            prompt: ["snowy las vegas streets",
//                                                     "snowy forest",
//                                                     "snowy sea",
//                                                     "snowy cabin",
//                                                     "ski resort",
//                                                     "snowing mountain"]),
//                      RecommendPromptResult(type: "outfit",
//                                            prompt: ["a long padding jumper",
//                                                     "shearling coat",
//                                                     "sweater",
//                                                     "board clothes",
//                                                     "santa clothes",
//                                                     "padded coat"])]
//            
//        case .ces:
//            
//            result = [RecommendPromptResult(type: "acc",
//                                                     prompt: ["stand in front of the microphone",
//                                                              "headset with microphone",
//                                                              "stand in front of casino gambling table",
//                                                              "wearing virtual reality headset",
//                                                              "staring at Mac-book, wearing glasses"]),
//                               RecommendPromptResult(type: "background",
//                                                     prompt: ["Las-Vegas casino",
//                                                              "Sunset LAS VEGAS",
//                                                              "IT start-up office",
//                                                              "Las Vegas Concert Hall",
//                                                              "CES exhibition, stand in front of mobile IT booth",
//                                                              "the city skyline forming a striking silhouette against the dark sky"
//                                                             ]),
//                               RecommendPromptResult(type: "outfit",
//                                                     prompt: ["robot costume",
//                                                              "casino gambling attire",
//                                                              "black hoodie",
//                                                              "Casual Check Shirt",
//                                                              "light gray hoodie",
//                                                              "man suit"])]
//            
//        }
//        return RecommendKeywordPromptsResult(data: result)
//    }
//}
