//
//  Data+.swift
//  ZOOC
//
//  Created by 장석우 on 11/26/23.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
