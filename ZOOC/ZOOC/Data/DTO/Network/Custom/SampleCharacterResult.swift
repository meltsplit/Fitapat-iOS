//
//  SampleCharacterResult.swift
//  ZOOC
//
//  Created by 류희재 on 2/2/24.
//

import Foundation

struct CharacterResult: Decodable {
    let id: Int
    let petName: String
    let image: String
}

extension CharacterResult {
    static func getMock() -> [CharacterResult] {
        return []
    }
}
