//
//  PatchUserRequest.swift
//  ZOOC
//
//  Created by 장석우 on 3/11/24.
//

import Foundation

struct UserInfoRequest: Encodable {
    let agreement: AgreementRequest
    let name: String?
    let phone: String?
}

struct AgreementRequest: Encodable {
    let marketing: Bool
}
