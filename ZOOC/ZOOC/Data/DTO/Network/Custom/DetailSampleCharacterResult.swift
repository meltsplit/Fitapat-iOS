//
//  DetailSampleCharacterResult.swift
//  ZOOC
//
//  Created by 류희재 on 2/3/24.
//

struct DetailSampleCharacterResult: Decodable {
    let id: Int
    let petName, image: String
    let keyword: SampleCharacterKeywordResult
    let concept: CustomConceptResult
}

struct SampleCharacterKeywordResult: Decodable {
    let outfit: PromptDTO?
    let accessory: PromptDTO?
    let background: PromptDTO?
}

extension DetailSampleCharacterResult {
    func toEntity() -> DetailCustomEntity {
        var keywordData: [CustomKeywordType : PromptDTO?] = [:]
        
        [CustomKeywordType.outfit : keyword.outfit,
         CustomKeywordType.accesorry : keyword.accessory,
         CustomKeywordType.background : keyword.background].forEach {
            if $0.value != nil { keywordData[$0.key] = $0.value }
        }
        let sortedKeywordData = keywordData.sorted { $0.key < $1.key }
        
        return DetailCustomEntity(
            characterData: CharacterResult(
                id: id,
                petName: petName,
                image: image
            ),
            keywordData: sortedKeywordData,
            hasPurchased: false,
            createdAt: nil,
            concept: concept
        )
    }
}
