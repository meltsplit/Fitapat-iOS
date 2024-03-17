//
//  AuthTargetType.swift
//  ZOOC
//
//  Created by 류희재 on 1/6/24.
//

import UIKit

import Moya

enum AuthTargetType {
    case getUserCheck(_ token: String, _ provider: String)
    case login(_ token: String, _ provider: String)
    case signUp(_ provider: String, _ token: String, _ request: Data)
    
    case postKakaoSocialLogin(_ accessToken: String)
    case postAppleSocialLogin(_ idToken: String)
    case postRefreshToken
}

extension AuthTargetType: BaseTargetType {
    var path: String {
        switch self {
        case .getUserCheck:
            return URLs.userCheck
        case .login:
            return URLs.signin
        case .signUp:
            return URLs.signUp
        case .postKakaoSocialLogin:
            return URLs.kakaoLogin
        case .postAppleSocialLogin:
            return URLs.appleLogin
        case .postRefreshToken:
            return URLs.refreshToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserCheck:
            return .get
        case .login:
            return .post
        case .signUp:
            return .post
        case .postKakaoSocialLogin:
            return .post
        case .postAppleSocialLogin:
            return .post
        case .postRefreshToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserCheck(_, let provider):
            return .requestParameters(parameters: ["provider": provider], encoding: URLEncoding.queryString)
        case .login(_, let provider):
            return .requestParameters(parameters: ["provider": provider], encoding: URLEncoding.queryString)
        case .signUp(let provider,_ ,let request):
            return .requestCompositeData(
                bodyData: request,
                urlParameters: ["provider" : provider]
            )
        case .postKakaoSocialLogin:
            return .requestPlain
        case .postAppleSocialLogin(let idToken):
            return .requestParameters(
                parameters: ["identityTokenString" : idToken],
                encoding: JSONEncoding.default
            )
        case .postRefreshToken:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        switch self {
        case .getUserCheck(let token, _):
            return [APIConstants.contentType: APIConstants.applicationJSON,
                    APIConstants.auth : token]
        case .login(let token, _):
            return [APIConstants.contentType: APIConstants.applicationJSON,
                    APIConstants.auth : token]
        case .signUp(_,let token, _):
            return [APIConstants.contentType: APIConstants.applicationJSON,
                    APIConstants.auth : token]
            
        case .postKakaoSocialLogin(accessToken: let accessToken):
            return [APIConstants.contentType: APIConstants.applicationJSON,
                    APIConstants.auth : accessToken]
        case .postAppleSocialLogin:
            return APIConstants.noTokenHeader
        case .postRefreshToken:
            return APIConstants.refreshHeader
        }
    }
}

