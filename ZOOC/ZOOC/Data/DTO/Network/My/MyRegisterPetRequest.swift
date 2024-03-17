//
//  MyRegisterPetRequest.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/17.
//

import UIKit

struct MyRegisterPetRequest: Codable {
    var name: String
    var breed: String?
    
    init(name: String = "", breed: String? = nil) {
        self.name = name
        self.breed = breed
    }
}
