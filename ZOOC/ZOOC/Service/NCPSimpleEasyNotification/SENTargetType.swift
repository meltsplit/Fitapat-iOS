//
//  SENTargetType.swift
//  ZOOC
//
//  Created by 장석우 on 3/6/24.
//

import Foundation
import Moya
import CommonCrypto

enum SENTargetType {
    case sendMessage(_ request: SimpleEasyNotificationRequest)
    
    func makeNCPHeader() -> [String : String] {
        
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
        
        let message = method.rawValue + " " + path + "\n" + timestamp + "\n" + Config.ncpAcessKeyID
        let keyData = Config.ncpSecretKey.data(using: .utf8)!
        var macOut = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyData.withUnsafeBytes { keyBytes in
            CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), 
                   keyBytes.baseAddress,
                   keyData.count,
                   message,
                   message.utf8.count,
                   &macOut)
        }
        
        let hmacData = Data(bytes: macOut, count: Int(CC_SHA256_DIGEST_LENGTH))
        let base64Encoded = hmacData.base64EncodedString()
        
        return [
            "Content-Type" : "application/json",
            "x-ncp-apigw-timestamp" : timestamp,
            "x-ncp-iam-access-key" : Config.ncpAcessKeyID,
            "x-ncp-apigw-signature-v2" : base64Encoded
        ]
    }
}

extension SENTargetType: TargetType {
    var baseURL: URL {
        URL(string: "https://sens.apigw.ntruss.com")!
    }
    
    var path: String {
        switch self {
        case .sendMessage:
            return "/sms/v2/services/\(Config.ncpServiceID)/messages"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .sendMessage:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sendMessage(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        return makeNCPHeader()
    }
    
    
}

