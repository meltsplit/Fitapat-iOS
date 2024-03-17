//
//  PetResult.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/12.
//

import UIKit

struct PetResult: Codable {
    let id: Int
    let name: String
    let breed: String?
    let photo: String?
    var datasetID: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, photo, breed
        case datasetID = "dataset_id"
    }
    
    init(id: Int = Int(),
         name: String = String(),
         breed: String? = nil,
         photo: String? = nil,
         datasetID: String? = nil) {
        self.id = id
        self.name = name
        self.breed = breed
        self.photo = photo
        self.datasetID = datasetID
    }
}

extension PetResult {
    func toEdit() -> EditProfileRequest {
        var profileImg: Data?
        if let urlString = self.photo {
            if let url = URL(string: urlString) {
                url.fetchData { data in
                    if let data = data {
                        profileImg = data
                    }
                }
            }
        }
        return EditProfileRequest(
            id: self.id,
            photo: self.photo != nil,
            name: self.name,
            breed: self.breed,
            file: profileImg
        )
    }
}
