//
//  GenAISelectImageViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI
import MobileCoreServices

final class GenAISelectImageViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let genAISelectImageUseCase: GenAISelectImageUseCase
    
    private var retryWithPet: PetResult? //너의 신성한 뷰모델을 망쳐서 미안해...
    
    init(genAISelectImageUseCase: GenAISelectImageUseCase,
         retryWithPet: PetResult? = nil) {
        self.genAISelectImageUseCase = genAISelectImageUseCase
        self.retryWithPet = retryWithPet
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var generateAIModelButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var petImageDatasets = BehaviorRelay<[UIImage]>(value: [])
        var ableToShowImages = BehaviorRelay<Bool>(value: false)
        var showToast = PublishRelay<String>()
        var imageUploadDidBegin = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(onNext: {
            self.genAISelectImageUseCase.loadImageEvent()
        }).disposed(by: disposeBag)
        
        input.generateAIModelButtonDidTapEvent.subscribe(with: self, onNext: { owner, _ in
            owner.genAISelectImageUseCase.handlePetData(owner.retryWithPet)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        genAISelectImageUseCase.petImageDatasets
            .bind(to: output.petImageDatasets)
            .disposed(by: disposeBag)
        
        genAISelectImageUseCase.ableToShowImages
            .bind(to: output.ableToShowImages)
            .disposed(by: disposeBag)
        
        genAISelectImageUseCase.registerError
            .bind(to: output.showToast)
            .disposed(by: disposeBag)
        
        genAISelectImageUseCase.makeDataSetError
            .bind(to: output.showToast)
            .disposed(by: disposeBag)
        
        genAISelectImageUseCase.imageUploadDidBegin
            .bind(to: output.imageUploadDidBegin)
            .disposed(by: disposeBag)
    }
}
    
