//
//  Syllable.swift
//  ZOOC
//
//  Created by 장석우 on 2/12/24.
//

import Foundation

enum Syllable {
    static let start받침Unicode = 0x11A8
    static let countOf받침: UInt32 = 27
    /// ㄱㄲ...ㅍㅎ' ' (27 + 1개)
    static var 받침List: [String] {
        let startUnicodeScalar = UnicodeScalar(start받침Unicode)!
        return [""] + (startUnicodeScalar.value..<startUnicodeScalar.value + countOf받침)
            .map { String($0, radix: 16) }
            .compactMap { UnicodeScalar(Int($0, radix: 16) ?? 0) }
            .map { String(Character($0)) }
    }
    
//    static func is받침(_ string: String?) -> Bool {
//        guard let string else { return false }
//        guard let 마지막 = string.last else { return false }
//        print(마지막)
//        print(Self.받침List.contains(String(마지막)))
//        return Self.받침List.contains(String(마지막))
//    }
    
    static func is받침(_ string: String?) -> Bool {
        guard let string else { return false }
        guard let lastText = string.last else { return false }
        let unicodeVal = UnicodeScalar(String(lastText))?.value
        guard let value = unicodeVal else { return false }
        if (value < 0xAC00 || value > 0xD7A3) { return false }
        let last = (value - 0xAC00) % 28
        return  last > 0
    }

}
