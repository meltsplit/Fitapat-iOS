//
//  DetailCharacterResult.swift
//  ZOOC
//
//  Created by 류희재 on 2/5/24.
//

struct DetailCharacterResult: Decodable {
    let id: Int
    let image: String
    let keyword: CharacterKeywordResult
    let concept: CustomConceptResult
    let hasPurchased: Bool
    let createdAt: String
}

struct CharacterKeywordResult: Decodable {
    let outfit: String?
    let accessory: String?
    let background: String?
}


extension DetailCharacterResult {
    func toEntity() -> DetailCustomEntity {
        var keywordData: [CustomKeywordType: PromptDTO] = [:]
        [CustomKeywordType.background :  keyword.background,
         CustomKeywordType.outfit : keyword.outfit,
         CustomKeywordType.accesorry : keyword.accessory
        ].forEach {
            if $0.value != nil {
                keywordData[$0.key] = PromptDTO(keywordKo: $0.value)
            }
        }
        let sortedKeywordData = keywordData.sorted { $0.key < $1.key }
        
        return DetailCustomEntity(
            characterData: CharacterResult(
                id: id,
                petName: nil,
                image: image
            ),
            keywordData: sortedKeywordData,
            hasPurchased: hasPurchased,
            createdAt: createdAt,
            concept: concept
        )
    }
}
