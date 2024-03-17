//
//  Direction+.swift
//  ZOOC
//
//  Created by 장석우 on 11/6/23.
//

import UIKit

enum HorizontalSwipe {
    case left
    case right
}

extension UISwipeGestureRecognizer.Direction {
    func transform() -> HorizontalSwipe {
        switch self {
        case .left: return .right
        case .right: return .left
        default: return .left
        }
    }
}
