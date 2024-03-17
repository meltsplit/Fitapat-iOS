//
//  InfoLiteral.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/25.
//

import Foundation

struct Config {
    
    static let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APPKEY"] as! String
    static let ncpAcessKeyID = Bundle.main.infoDictionary?["NCP_ACCESS_KEY_ID"] as! String
    static let ncpCallingNumber = Bundle.main.infoDictionary?["NCP_CALLING_NUMBER"] as! String
    static let ncpSecretKey = Bundle.main.infoDictionary?["NCP_SECRET_KEY"] as! String
    static let ncpServiceID = Bundle.main.infoDictionary?["NCP_SERVICE_ID"] as! String
    static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as! String
    static let baseWebURL = Bundle.main.infoDictionary?["BASE_WEB_URL"] as! String
    static let baseWebServerURL = Bundle.main.infoDictionary?["BASE_WEB_SERVER_URL"] as! String

    static let sentryDSN = "https://d231bfb30d614722b80fa6f2fe5c43f5@o4505115856666624.ingest.sentry.io/4505115938127872"
    
}
