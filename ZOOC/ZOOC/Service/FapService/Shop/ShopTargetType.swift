//
//  ShopService.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/30.
//

import Foundation

import Moya

enum ShopTargetType {
    case getPopularProducts
}

extension ShopTargetType: BaseTargetType {
    var baseURL: URL {
        return URL(string: Config.baseWebServerURL)!
    }
    var path: String {
        switch self {
        case .getPopularProducts:
            return "/product/self-custom/popular/v1"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularProducts:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPopularProducts:
            return .requestPlain
        }
    }
}
