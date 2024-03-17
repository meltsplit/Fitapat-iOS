//
//  PetTargetType.swift
//  ZOOC
//
//  Created by 장석우 on 11/21/23.
//

import Foundation

import Moya

enum PetTargetType {
    case getPet
    case patchPet(request: EditProfileRequest)
    case getPetDatasetInfo(_ petID: Int)
    case postDataset(_ petID: Int)
    case postRegisterPet(_ request: MyRegisterPetRequest)
}

extension PetTargetType: BaseTargetType {
    
    var path: String {
        switch self {
        case .getPet:
            return URLs.getPet
        case .patchPet(let request):
            return URLs.patchPet
                .replacingOccurrences(
                    of: "{petId}",
                    with: String(request.id)
                )
        case .getPetDatasetInfo(let petID):
            return URLs.getPetDataset
                .replacingOccurrences(
                    of: "{petId}",
                    with: String(petID)
                )
        case .postDataset:
            return URLs.postDataset
        case .postRegisterPet(param: _):
            return URLs.registerPet
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPet:
            return .get
        case .patchPet:
            return .patch
        case .getPetDatasetInfo:
            return .get
        case .postDataset:
            return .post
        case .postRegisterPet(param: _):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPet:
            return .requestPlain
        case .patchPet(let request):
            var multipartFormData: [MultipartFormData] = []
            
            if let file = request.file {
                let imageData = MultipartFormData(
                    provider: .data(file),
                    name: "file",
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg")
                multipartFormData.append(imageData)
            }
            
            multipartFormData.append(
                MultipartFormData(
                    provider: .data("\(request.name)".data(using: .utf8)!),
                    name: "nickName")
            )
            
            if let breed = request.breed {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(breed.data(using: .utf8)!),
                        name: "breed")
                )
            }
            return .uploadMultipart(multipartFormData)
        case .getPetDatasetInfo:
            return .requestPlain
        case .postDataset(let petId):
            return .requestJSONEncodable(["petId": petId])
        case .postRegisterPet(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .patchPet:
            return APIConstants.multipartHeader
        default:
            return APIConstants.hasTokenHeader
        }
    }
}
