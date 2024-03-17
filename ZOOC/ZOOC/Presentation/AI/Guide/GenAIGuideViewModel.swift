//
//  GenAIGuideViewModel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/24.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

final class GenAIGuideViewModel: ViewModelType {
    internal var disposeBag = DisposeBag()
    private let genAIGuideUseCase: GenAIGuideUseCase
    
    init(genAIGuideUseCase: GenAIGuideUseCase) {
        self.genAIGuideUseCase = genAIGuideUseCase
    }
    
    struct Input {
        var viewWillAppearEvent: Observable<Void>
        var viewWillDisappearEvent: Observable<Void>
        var didFinishPickingImageEvent: Observable<[PHPickerResult]>
    }
    
    struct Output {
        var selectedImageDatasets = BehaviorRelay<[PHPickerResult]>(value: [])
        var ableToPhotoUpload = BehaviorRelay<Bool?>(value: nil)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
        input.viewWillAppearEvent.subscribe(onNext: {
            self.genAIGuideUseCase.checkPresentPHPPickerVC()
        }).disposed(by: disposeBag)
        
        input.viewWillDisappearEvent.subscribe(onNext: {
            self.genAIGuideUseCase.clearImageDatasets()
        }).disposed(by: disposeBag)
        
        input.didFinishPickingImageEvent.subscribe(onNext: { result in
            self.genAIGuideUseCase.canUploadImageDatasets(result)
        }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindOutput(output: Output, disposeBag: DisposeBag) {
        genAIGuideUseCase.selectedImageDatasets
            .bind(to: output.selectedImageDatasets)
            .disposed(by: disposeBag)
        
        genAIGuideUseCase.ableToPhotoUpload
            .bind(to: output.ableToPhotoUpload)
            .disposed(by: disposeBag)
    }
}

extension GenAIGuideViewModel {
    func getSelectedImageDatasets() -> [PHPickerResult] {
        return genAIGuideUseCase.selectedImageDatasets.value
    }
    
    func getName() -> String {
        return genAIGuideUseCase.name!
    }
    
    func getBreed() -> String? {
        return genAIGuideUseCase.breed
    }
}
