//
//  GenAIGuideUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/20.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

protocol GenAIGuideUseCase {
    var name: String? { get }
    var breed: String? { get }
    var selectedImageDatasets: BehaviorRelay<[PHPickerResult]> { get }
    var ableToPhotoUpload: BehaviorRelay<Bool?> { get }
    var isPushed: BehaviorRelay<Bool?> { get }
    var isPopped: BehaviorRelay<Bool> { get }
    
    func clearImageDatasets()
    func canUploadImageDatasets(_ result: [PHPickerResult])
    func pushToSelectImageVCEvent()
    func checkPresentPHPPickerVC()
}
