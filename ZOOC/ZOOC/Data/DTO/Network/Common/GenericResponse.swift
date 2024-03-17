//
//  GenericResponse.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation

struct GenericResponse<T: Decodable>: Decodable {
    var status: Int
    var data: T?
    
    enum CodingKeys: CodingKey {
        case status
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = (try? container.decode(Int.self, forKey: .status)) ?? 500
        self.data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}
