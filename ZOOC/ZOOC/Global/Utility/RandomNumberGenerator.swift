//
//  RandomNumberGenerator.swift
//  ZOOC
//
//  Created by 장석우 on 3/11/24.
//

import Foundation

struct RandomNumberGenerator {
    
    static func create(length: Int) -> String {
        let digits = "0123456789"
        var randomString = ""
        
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(digits.count)))
            let digit = digits[String.Index(utf16Offset: index, in: digits)]
            randomString.append(digit)
        }
        
        return randomString
    }
}
