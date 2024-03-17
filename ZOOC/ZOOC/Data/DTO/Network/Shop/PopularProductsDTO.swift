//
//  PopularProducts.swift
//  ZOOC
//
//  Created by 장석우 on 2/13/24.
//

import Foundation

struct PopularProductsDTO: Decodable {
    let id : Int
    let name : String
    let sale : Int
    let price: Int
    let image : String
}
