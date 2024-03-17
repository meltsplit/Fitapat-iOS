//
//  TransitionEventDTO.swift
//  ZOOC
//
//  Created by 장석우 on 1/29/24.
//

import Foundation

struct TransitionEventDTO: Decodable {
    let action: String
    let url: String?
    let index: Int?
}

//MARK: - TransitionEventDTO 의 action에는 TransitionAction의 문자열을 보내주기로 Web과 약속하였음.
// https://www.notion.so/30be39ea2a1b4431825ba3dd4a6277bb?pvs=4

enum TransitionAction: String {
    case PUSH
    case POP
    case PRESENT
    case DISMISS
    case POPTOROOT
    case SWITCHTAB
    case unknown
}
