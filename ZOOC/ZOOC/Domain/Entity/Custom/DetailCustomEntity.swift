//
//  DetailCustomEntity.swift
//  ZOOC
//
//  Created by 류희재 on 2/5/24.
//

import Foundation

struct DetailCustomEntity {
    let characterData: CharacterResult
    let keywordData: [(CustomKeywordType, PromptDTO?)]
    let hasPurchased: Bool
    let createdAt: String?
    let concept: CustomConceptResult
}
