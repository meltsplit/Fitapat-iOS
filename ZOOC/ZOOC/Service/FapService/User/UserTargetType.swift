//
//  UserTargetType.swift
//  ZOOC
//
//  Created by 류희재 on 1/12/24.
//

import UIKit

import Moya

enum UserTargetType {
    case patchFCMToken(_ fcmToken: String)
    case getTicket
    case patchUser(_ request: UserInfoRequest)
    case deleteAccount
    case logout
}

extension UserTargetType: BaseTargetType {
    var path: String {
        switch self {
        case .patchFCMToken:
            return URLs.fcmToken
        case .patchUser(_):
            return "/user"
        case .getTicket:
            return "/user/ticket"
        case .deleteAccount:
            return URLs.deleteUser
        case .logout:
            return URLs.logout

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchFCMToken:
            return .put
        case .patchUser(_):
            return .patch
        case .getTicket:
            return .get
        case .deleteAccount:
            return .delete
        case .logout:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchFCMToken(let fcmToken):
            return .requestParameters(
                parameters: ["fcmToken": fcmToken],
                encoding: JSONEncoding.default
            )
        case .patchUser(let request):
            return .requestJSONEncodable(request)
        case .getTicket:
            return .requestPlain
        case .deleteAccount:
            return .requestPlain
        case .logout:
            return .requestParameters(
                parameters: ["fcmToken": UserDefaultsManager.fcmToken],
                encoding: JSONEncoding.default
            )
        }
    }
}
