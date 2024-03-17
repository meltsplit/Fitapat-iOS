//
//  DefaultGenAIGuideUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/20.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

final class DefaultGenAIGuideUseCase: GenAIGuideUseCase {
    private let disposeBag = DisposeBag()
    
    var name: String?
    var breed: String?
    var selectedImageDatasets = BehaviorRelay<[PHPickerResult]>(value: [])
    var ableToPhotoUpload = BehaviorRelay<Bool?>(value: nil)
    var isPushed = BehaviorRelay<Bool?>(value: nil)
    var isPopped = BehaviorRelay<Bool>(value: false)
    
    init(name: String?, breed: String?) {
        self.name = name
        self.breed = breed
    }

    func clearImageDatasets() {
        selectedImageDatasets.accept([])
    }
    
    func canUploadImageDatasets(_ result: [PHPickerResult]) {
        if 8 <= result.count && result.count <= 15 {
            selectedImageDatasets.accept(result)
            ableToPhotoUpload.accept(true)
        } else {
            selectedImageDatasets.accept([])
            ableToPhotoUpload.accept(false)
        }
     }
    
    func pushToSelectImageVCEvent() {
        isPushed.accept(true)
    }
    
    func checkPresentPHPPickerVC() {
        guard let isPushed = isPushed.value else { return }
        isPopped.accept(isPushed)
    }
}
