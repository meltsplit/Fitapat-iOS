//
//  CustomCharacterResult.swift
//  ZOOC
//
//  Created by 류희재 on 2/3/24.
//

import Foundation

struct CustomCharacterResult: Decodable {
    let id: Int
    let image: String
    let hasPurchased: Bool
    let conceptName: String
    let createdAt: String
}

extension [CustomCharacterResult] {
    func toDomain() -> [[String : [CustomCharacterResult]]] {
        var array: [[String : [CustomCharacterResult]]] = []
        let dic = Dictionary(
            grouping: self,
            by: { $0.createdAt.toDate() }
        )
        let sortedDic = dic.sorted { $0.key > $1.key }
        for (key, value) in sortedDic {
            let dictionary: [String: [CustomCharacterResult]] = [key: value]
            array.append(dictionary)
        }
        return array
    }
}
