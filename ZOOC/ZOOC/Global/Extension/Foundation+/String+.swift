//
//  String+.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import Foundation

extension String {
    
    var hasText: Bool {
        return !isEmpty
    }
    
    func isMoreThan(_ length: Int) -> Bool {
        return self.count > length
    }
    
    func transform() -> AppVersion {
        self.split(separator: ".").map { Int($0) ?? 0 }
    }
    
    var isConsonant: Bool {
        guard let scalar = UnicodeScalar(self)?.value else {
            return false
        }
        
        let consonantScalarRange: ClosedRange<UInt32> = 12593...12622
        
        return consonantScalarRange ~= scalar
    }
    
    
    // MARK: - 휴대폰 번호 검증
    public func validatePhone(number: String) -> Bool {
        let regex = "^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: number)
    }
    
    public var isBase64: Bool {
        let pattern = #"^[A-Za-z0-9+/]{4}([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$"#
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.utf16.count)
        
        return regex?.firstMatch(in: self, options: [], range: range) != nil
    }
    
    public var withHypen: String {
        var stringWithHypen: String = self
        
        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
        stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        
        return stringWithHypen
    }
    
    func toDate() -> String {
        let year = self.substring(from: 0, to: 3)
        let month = self.substring(from: 5, to: 6)
        let day = self.substring(from: 8, to: 9)
        let date = "\(year). \(month). \(day)"
        return date
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
