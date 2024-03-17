//
//  MyEditProfileViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

final class MyEditProfileViewModel: ViewModelType {
    private let myEditProfileUseCase: MyEditProfileUseCase
    
    init(myEditProfileUseCase: MyEditProfileUseCase) {
        self.myEditProfileUseCase = myEditProfileUseCase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var nameDidChangeEvent: Observable<String>
        var breedDidChangeEvent: Observable<String>
        var selectProfileImageEvent: Observable<Data?>
        var deleteProfileImageEvent: Observable<Void>
        var editButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        var petResult = PublishRelay<PetResult>()
        var isEdited = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(with: self, onNext: { owner, _ in
            guard let petResult = owner.myEditProfileUseCase.getPetResult() else { return }
            output.petResult.accept(petResult)
        }).disposed(by: disposeBag)
        
        input.nameDidChangeEvent.subscribe(with: self, onNext: { owner, name in
            owner.myEditProfileUseCase.updateName(name)
        }).disposed(by: disposeBag)
        
        input.breedDidChangeEvent.subscribe(with: self, onNext: { owner, breed in
            owner.myEditProfileUseCase.updateBreed(breed)
        }).disposed(by: disposeBag)
        
        input.selectProfileImageEvent.subscribe(with: self, onNext: { owner, image in
            owner.myEditProfileUseCase.selectProfileImage(image)
        }).disposed(by: disposeBag)
        
        input.deleteProfileImageEvent.subscribe(with: self, onNext: { owner, _ in
            owner.myEditProfileUseCase.deleteProfileImage()
        }).disposed(by: disposeBag)
        
        input.editButtonTapEvent.subscribe(with: self, onNext: { owner, _  in
            owner.myEditProfileUseCase.editProfile()
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {        
        myEditProfileUseCase.editSuccess
            .bind(to: output.isEdited)
            .disposed(by: disposeBag)
    }
}
