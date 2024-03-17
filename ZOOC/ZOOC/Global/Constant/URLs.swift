//
//  URL.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/31.
//

import Foundation

public enum URLs{
    
    //MARK: - App
    
    static let getNotice = "/alarm/list/{familyId}"
    
    //MARK: - Pet
    
    static let getPet = "/pet"
    static let registerPet = "/pet"
    static let patchPet = "/pet/{petId}"
    
    //MARK: - User
    
    static let userCheck = "/user"
    static let signin = "/user/signin"
    static let signUp = "/user/signup/v2"
    
    
    static let kakaoLogin = "/user/kakao/signin"
    static let appleLogin = "/user/apple/signin"
    static let refreshToken = "/user/refresh"
    static let editProfile = "/user/profile"
    static let deleteUser = "/user"
    static let fcmToken = "/user/fcm_token"
    static let logout = "/user/signout"
    
    
    //MARK: - AI
    
    static let postDataset = "/ai/dataset"
    static let getPetDataset = "/ai/dataset/{petId}"
    static let patchDatasetImage = "/ai/image/{datasetId}"
    static let patchDatasetImages = "/ai/images/{datasetId}"
    static let postKeywordsPrompt = "/ai/image/albedo/{petId}"
    static let postGenerationPetImage = "/ai/image/{petId}"
    
    //MARK: - Shop
    
    static let getTotalProducts = "/shop/product"
    static let getProduct = "/shop/product/{productId}"
    static let postOrder = "/shop/order"
    
    //MARK: - Concept
    
    static let concept = "/concept"
    
    //MARK: - Character
    
    static let getSampleCharacter = "/sample-character"
    static let getDetailSampleCharacter = "/sample-character/{characterId}"
    
    static let character = "/character"
    static let getDetailCharacter = "/character/{characterId}"
    
}
