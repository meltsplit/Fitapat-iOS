//
//  Concept.swift
//  ZOOC
//
//  Created by 장석우 on 12/28/23.
//

import UIKit

struct CustomConceptResult: Decodable, Equatable {
    let id: Int
    let name: String
    let description: String
    let image: String 
}

extension CustomConceptResult {
    
    static func commingSoon() -> CustomConceptResult {
        return .init(id: -12341234, name: "commingSoon", description: "commingSoon", image: "commingSoon")
    }
    static func getMock() -> [CustomConceptResult] {
        return [
            CustomConceptResult(id: 1, name: "마법학교", description: "{pet}가 마법사가 된다면", image: "https://i.ibb.co/ZTzS24g/winter.png"),
            CustomConceptResult(id: 2, name: "겨울", description: "{pet}가 마법사가 된다면", image: "https://i.imgur.com/bV2yh72.png"),
        ]
    }
}


enum CustomConceptMock: CaseIterable {
    case magic
    case winter
    case ces
    
    var title: String {
        switch self {
        case .magic:
            return String(localized: "마법학교")
        case .winter:
            return String(localized: "겨울")
        case .ces:
            return String(localized: "2024 CES")
        }
    }
    
    var description: String {
        switch self {
        case .magic:
            return String(localized: "윙가르디움 레비오우사!")
        case .winter:
            return String(localized: "날씨가 많이 쌀쌀해졌네요")
        case .ces:
            return String(localized: "CES 박람회에 참여했어요")
        }
    }
    
    var thumbnail: UIImage {
        switch self {
        case .magic:
            return .mockMagic
        case .winter:
            return .mockWinter
        case .ces:
            return .mockCes
        }
    }
    
    var defaultBackgroundPrompt: String {
        switch self {
        case .magic:
            return String(localized: "Hogwarts school")
        case .winter:
            return String(localized: "snowing mountain")
        case .ces:
            return String(localized: "CES exhibition, stand in front of mobile IT booth")
        }
    }
    
}
