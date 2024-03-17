//
//  DefaultMyEditProfileUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DefaultMyEditProfileUseCase: MyEditProfileUseCase {
    private let petRepository: PetRepository
    private let disposeBag = DisposeBag()
    
    init(
        petRepository: PetRepository
    ) {
        self.petRepository = petRepository
        self.editProfileData = petRepository.petResult?.toEdit()
    }
    
    var editProfileData: EditProfileRequest?
    var editSuccess = PublishRelay<Bool>()
}

extension DefaultMyEditProfileUseCase {
    func getPetResult() -> PetResult? {
        return petRepository.petResult
    }
    
    func updateName(_ name: String) {
        self.editProfileData?.name = name
    }
    
    func updateBreed(_ breed: String) {
        self.editProfileData?.breed = breed
    }
    
    func selectProfileImage(_ image: Data?) {
        guard let image else { return }
        self.editProfileData?.file = image
    }
    
    func deleteProfileImage() {
        self.editProfileData?.file = nil
    }
    
    func editProfile() {
        guard let request = editProfileData else { return }
        petRepository.patchPet(request)
            .subscribe(with: self, onNext: { owner, editSuccess in
                owner.editSuccess.accept(editSuccess)
                NotificationCenter.default.post(name: .refreshCustom, object: nil)
            }).disposed(by: disposeBag)
    }
}
   
