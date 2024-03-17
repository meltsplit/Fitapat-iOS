//
//  MyEditProfileUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol MyEditProfileUseCase {
    var editProfileData: EditProfileRequest? { get }
    var editSuccess: PublishRelay<Bool> { get }
    
    func getPetResult() -> PetResult?
    func updateName(_ name: String)
    func updateBreed(_ breed: String)
    func deleteProfileImage()
    func selectProfileImage(_ image: Data?)
    func editProfile()
}
