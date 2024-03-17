//
//  GenAISelectImageUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/21.
//

import RxSwift
import RxCocoa
import PhotosUI

protocol GenAISelectImageUseCase {
    var name: String? { get }
    var breed: String? { get }
    var selectedImageDatasets: BehaviorRelay<[PHPickerResult]> { get }
    
    var petImageDatasets: BehaviorRelay<[UIImage]> { get }
    var ableToShowImages: PublishRelay<Bool> { get }
    var registerError: PublishRelay<String> { get }
    var makeDataSetError: PublishRelay<String> { get }
    var imageUploadDidBegin: PublishRelay<Bool> { get }
    
    func handlePetData(_ retryWithPet: PetResult?)
    func loadImageEvent()
}

