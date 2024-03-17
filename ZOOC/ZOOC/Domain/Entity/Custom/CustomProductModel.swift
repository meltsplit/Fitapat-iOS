//
//  CustomProductModel.swift
//  ZOOC
//
//  Created by 류희재 on 12/18/23.
//

import UIKit

struct CustomProductModel {
    let productImage: UIImage
    let title: String
    let price: String
}

extension CustomProductModel {
    static let productDummyData = [
        CustomProductModel(
            productImage: .mockHoodie,
            title: "2023 캘린더",
            price: "23,000"
        ),
        CustomProductModel(
            productImage: .mockHidi,
            title: "2023 캘린더",
            price: "23,000"
        ),
        CustomProductModel(
            productImage: .mockSeokwoo,
            title: "2023 캘린더",
            price: "23,000"
        ),
        CustomProductModel(
            productImage: .mockHoodie,
            title: "2023 캘린더",
            price: "23,000"
        ),
        CustomProductModel(
            productImage: .icBack,
            title: "2023 캘린더",
            price: "23,000"
        ),
        CustomProductModel(
            productImage: .mockSeokwoo,
            title: "2023 캘린더",
            price: "23,000"
        )
    ]
}
