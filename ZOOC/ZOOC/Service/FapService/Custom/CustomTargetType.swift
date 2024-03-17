//
//  CustomTargetType.swift
//  ZOOC
//
//  Created by 류희재 on 12/22/23.
//

import UIKit

import Moya

enum CustomTargetType {
    case getConcpet
    case getSampleCharacter(_ conceptId: Int)
    case getDetailSampleCharacter(_ characterID: Int)
    
    case getCharacter
    case getDetailCharacter(_ characterID: Int)
    
    case postKeywordPrompts(_ petId: Int, _ request: [String: String])
    case getReommedKeywordsPrompts(_ conceptID: Int)
    case postCharacter(_ request: MakeCharacterRequest)
}

extension CustomTargetType: BaseTargetType {
    var path: String {
        switch self {
        case .getConcpet:
            return URLs.concept
        case .getSampleCharacter(let conceptID):
            return URLs.getSampleCharacter                .replacingOccurrences(of: "{conceptId}",
                                    with: "\(conceptID)")
        case .getDetailSampleCharacter(let characterID):
            return URLs.getDetailSampleCharacter
                .replacingOccurrences(of: "{characterId}",
                                      with: "\(characterID)")
        case .getCharacter:
            return URLs.character
        case .getDetailCharacter(let characterID):
            return URLs.getDetailCharacter
                .replacingOccurrences(of: "{characterId}",
                                      with: "\(characterID)")

        case .postKeywordPrompts(let petID, _):
            return URLs.postKeywordsPrompt
                .replacingOccurrences(of: "{petId}",
                                      with: "\(petID)")
        case .getReommedKeywordsPrompts:
            return "/keyword"
        case .postCharacter:
            return "/character"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getConcpet:
            return .get
        case .getSampleCharacter:
            return .get
        case .getDetailSampleCharacter:
            return .get
            
        case .getCharacter:
            return .get
        case .getDetailCharacter(_):
            return .get
            
        case .postKeywordPrompts:
            return .post
        case .getReommedKeywordsPrompts:
            return .get
        case .postCharacter:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getConcpet:
            return .requestPlain
        case .getSampleCharacter(let conceptID):
            return .requestParameters(parameters: ["conceptId" : conceptID], encoding: URLEncoding.queryString)
        case .getDetailSampleCharacter:
            return .requestPlain
            
        case .getCharacter:
            return .requestPlain
        case .getDetailCharacter:
            return .requestPlain
            
        case .postKeywordPrompts(_, let request):
            return .requestParameters(parameters: request, encoding: JSONEncoding.default)
        case .getReommedKeywordsPrompts(let conceptID):
            return .requestParameters(parameters: ["conceptId" : conceptID], encoding: URLEncoding.queryString)
        case .postCharacter(let request):
            return .requestJSONEncodable(request)
        }
    }
}
