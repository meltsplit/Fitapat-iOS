//
//  AuthDTO.swift
//  ZOOC
//
//  Created by 장석우 on 1/29/24.
//

import Foundation

struct AuthDTO: Encodable {
    let accessToken: String
    let refreshToken: String
}
