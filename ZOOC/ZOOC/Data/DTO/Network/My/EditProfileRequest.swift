//
//  MyEditProfileModel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/02/28.
//

import UIKit

struct EditProfileRequest {
    var id: Int
    var photo: Bool
    var name: String
    var breed: String?
    var file: Data?
    
    init(id: Int, photo: Bool, name: String, breed: String?, file: Data? = nil) {
        self.id = id
        self.photo = photo
        self.name = name
        self.breed = breed
        self.file = file
    }
}
