//
//  SimpleEasyNotificationRequest.swift
//  ZOOC
//
//  Created by 장석우 on 3/6/24.
//

import Foundation

struct SimpleEasyNotificationRequest: Encodable {
    let type: String
    let contentType: String
    let from: String
    let content: String
    let messages: [SimpleEasyMessageRequest]
    
    
    enum SENType: String {
        case SMS
        case LMS
        case MMS
    }
    
    enum ContentType: String {
        case COMM
        case AD
    }
    
    init(
        type: SENType = .SMS,
        contentType: ContentType = .COMM,
        from: String = Config.ncpCallingNumber,
        code: String,
        to: [String]
    ) {
        let messages = to.map { SimpleEasyMessageRequest(to: $0) }
        
        self.type = type.rawValue
        self.contentType = contentType.rawValue
        self.from = from
        self.content = "[핏어팻] 휴대폰 인증번호 [\(code)]를 입력해주세요."
        self.messages = messages
    }
    
}

struct SimpleEasyMessageRequest: Encodable {
    let to: String
}

