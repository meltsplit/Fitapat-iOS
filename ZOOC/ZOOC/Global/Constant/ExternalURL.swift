//
//  EnternalURL.swift
//  ZOOC
//
//  Created by 장석우 on 2023/05/14.
//

import Foundation


struct ExternalURL {
    static let localhost = "http://localhost:3000"
    static let fapWebURL = Config.baseWebURL
    
    static let fapDefaultURL = "https://melt-split.notion.site/Fitapat-db143aea709a452ba5a91f7dc31aad0f?pvs=4"
    static let termsOfUse = "https://melt-split.notion.site/8c417ba2156d4720b77f480d80ace49d?pvs=4"
    static let privacyPolicy = "https://melt-split.notion.site/65a11bf765b748678c8e6345cbfc6140?pvs=4"
    static let consentMarketing = "https://melt-split.notion.site/020167668a2b44e08dc15d95b0004643?pvs=4"
    static let onwardTransfer = "https://www.notion.so/melt-split/3-f551ffc7774e4560a3a3cc17dd3c39ef?pvs=4"
    static let fapChannelTalk = "https://fitapat.channel.io"
    static let orderHistory = "https://zooc-shopping.vercel.app/order"
    static let fapInstagram = "https://www.instagram.com/fitapat.official/"
    static let postCodeURL = "https://teamzooc.github.io/Kakao-Postcode/"
    
    
    
    static let meltGithub = "https://github.com/meltsplit"
    static let hidiGithub = "https://github.com/HELLOHIDI"
    
    
    
    static func zoocAppStore(_ appID: String = "1669547675") -> String {
        return "itms-apps://itunes.apple.com/app/\(appID)"
    }
    
    static func fapAppStoreKR(_ appID: String = "1669547675") -> String {
        return "https://apps.apple.com/kr/app/zooc/id\(appID)"
    }

}
