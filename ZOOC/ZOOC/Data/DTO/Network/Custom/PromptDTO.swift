//
//  PromptDTO.swift
//  ZOOC
//
//  Created by 장석우 on 2/3/24.
//

import Foundation

struct PromptDTO: Codable {
    let keywordKo: String?
    let keywordEn: String?
    
    init(keywordKo: String? = nil, keywordEn: String? = nil) {
        self.keywordKo = keywordKo
        self.keywordEn = keywordEn
    }
}
