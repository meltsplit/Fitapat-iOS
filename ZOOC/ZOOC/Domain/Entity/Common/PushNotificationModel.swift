//
//  PushNotificationModel.swift
//  ZOOC
//
//  Created by 장석우 on 11/27/23.
//

import Foundation

enum PushNotificationCase: String {
    case warnningWhenTerminate
    case resumeWithBackground
    
    var model: PushNotificationModel {
        switch self {
            
        case .warnningWhenTerminate:
            return .init(title: "앗, 반려동물 등록 중 강제 종료하셨네요!",
                         body: "이미지 업로드 도중 화면을 닫거나, 앱을 중단하면 업로드가 중단될 수 있어요",
                         id: self.rawValue,
                         timeInterval: 4)
        case .resumeWithBackground:
            return .init(title: "반려동물 정보를 등록하고 있어요",
                         body: "반려동물 등록이 완료되면 푸시 알림으로 알려드릴게요",
                         id: self.rawValue)
        }
    }
    
}

struct PushNotificationModel {
    let title: String
    let body: String
    let id: String
    let timeInterval: Int
    
    init(title: String, body: String, id: String, timeInterval: Int = 1) {
        self.title = title
        self.body = body
        self.id = id
        self.timeInterval = timeInterval
    }
}
