//
//  MakeCharacterRequest.swift
//  ZOOC
//
//  Created by 장석우 on 2/2/24.
//

import Foundation

struct MakeCharacterRequest: Encodable {
    let conceptId: Int
    let keyword: PromptsRequest
}

struct PromptsRequest: Encodable {
    let background: PromptDTO?
    let outfit: PromptDTO?
    let accessory: PromptDTO?
}
