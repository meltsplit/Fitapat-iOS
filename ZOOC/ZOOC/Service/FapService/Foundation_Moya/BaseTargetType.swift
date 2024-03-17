//
//  BaseTargetType.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType{ }

extension BaseTargetType{
    
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var headers: [String : String]? {
        return APIConstants.hasTokenHeader
    }
    
    var validationType: ValidationType {
        return .customCodes(Array(0...500).filter { $0 != 401 } )
    }
   
}
