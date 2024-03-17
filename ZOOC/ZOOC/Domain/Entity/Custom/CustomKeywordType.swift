//
//  CustomKeywordType.swift
//  ZOOC
//
//  Created by 장석우 on 12/17/23.
//

import Foundation

enum CustomKeywordType: String, Hashable {
    case accesorry
    case background
    case outfit
    
    var title: String {
        
        switch self {    
        case .accesorry:
            return "액세서리"
        case .background:
            return "배경"
        case .outfit:
            return "옷"
        }
    }
}

let order: [CustomKeywordType] = [.background, .outfit, .accesorry]

extension CustomKeywordType: Comparable {
    static func < (lhs: CustomKeywordType, rhs: CustomKeywordType) -> Bool {
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

