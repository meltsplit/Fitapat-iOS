//
//  DefaultGenAISelectImageUseCase.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/21.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

final class DefaultGenAISelectImageUseCase: GenAISelectImageUseCase {
    typealias ImageUploadManagerProtocol = ImageManagerSettable & ImageManagerResponseSendable & URLSessionTaskDelegate
    
    private var petRepository: PetRepository
    private let imageUploadManager: ImageUploadManagerProtocol
    
    private let disposeBag = DisposeBag()
    
    init(
        name: String,
        breed: String?,
        selectedImageDatesets: [PHPickerResult],
        repository: PetRepository,
        imageUploadManager: ImageUploadManagerProtocol
    ) {
        self.name = name
        self.breed = breed
        self.selectedImageDatasets.accept(selectedImageDatesets)
        self.petRepository = repository
        self.imageUploadManager = imageUploadManager
    }
    
    deinit {
        print("DefaultGenAISelectImageUseCase 죽는다")
    }
    
    
    var name: String? = nil
    var breed: String? = nil
    
    var selectedImageDatasets = BehaviorRelay<[PHPickerResult]>(value: [])
    
    var petImageDatasets = BehaviorRelay<[UIImage]>(value: [])
    
    var ableToShowImages = PublishRelay<Bool>()
    
    var registerError = PublishRelay<String>()
    var makeDataSetError = PublishRelay<String>()
    var imageUploadDidBegin = PublishRelay<Bool>()
    
    func loadImageEvent() {
        let dispatchGroup = DispatchGroup()
        var updatePetImageDatasets: [UIImage] = []
        
        for index in 0..<selectedImageDatasets.value.count {
            let itemProvider = selectedImageDatasets.value[index].itemProvider
            
            dispatchGroup.enter()
            itemProvider.loadImage { image, error in
                if let image = image {
                    DispatchQueue.main.async {
                        updatePetImageDatasets.append(image)
                        dispatchGroup.leave()
                    }
                }
                if let error = error {
                    print("Image Loading Error: \(error)")
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.petImageDatasets.accept(updatePetImageDatasets)
            if self.petImageDatasets.value.count > 0 && self.selectedImageDatasets.value.count == self.petImageDatasets.value.count {
                self.ableToShowImages.accept(true)
            } else {
                self.ableToShowImages.accept(false)
            }
        }
    }
    
    func handlePetData(_ retryWithPet: PetResult?) {
        guard let pet = retryWithPet else {
            registerPet()
            return
        }
        guard let datasetID = pet.datasetID else {
            makeDataSet(pet.id)
            return
        }
        uploadImages(datasetId: datasetID, files: petImageDatasets.value)
    }
    
    func registerPet() {
        let request = MyRegisterPetRequest(name: name!, breed: breed)
        petRepository.registerPet(request)
            .map { $0.id }
            .subscribe(with: self, onNext: { owner, id in
                owner.makeDataSet(id)
                NotificationCenter.default.post(name: .refreshCustom, object: nil)
            }, onError: { owner, _ in
                owner.registerError.accept("반려동물 등록 과정 중 오류가 발생했습니다.")
            }).disposed(by: disposeBag)
    }
    
    func makeDataSet(_ petId: Int) {
        petRepository.postMakeDataset(petId)
            .subscribe(with: self, onNext: { owner, result in
                owner.uploadImages(
                    datasetId: result.datasetId,
                    files: owner.petImageDatasets.value
                )
            }, onError: { owner, _ in
                owner.makeDataSetError.accept(("데이터셋을 만드는 과정 중 오류가 발생했습니다."))
            }).disposed(by: disposeBag)
    }
    
    func uploadImages(datasetId: String, files: [UIImage]) {
        self.imageUploadDidBegin.accept(true)
        Task {
            do {
                _ = try await petRepository.postPetImages(datasetID: datasetId,
                                                          files: files,
                                                          with: imageUploadManager)
                self.petRepository.updatePetInfo()
                self.imageUploadManager.responseSuccess()
            } catch {
                
                dump(error)
                let code = (error as NSError).code
                print(code)
                
                switch code {
                case -999: //백그라운드로 들어갔을 때
                    return self.imageUploadManager.responseFail(willContinue: true)
                case -1005: //인터넷 연결이 끊겼을 때
                    return self.imageUploadManager.responseFail(willContinue: false)
                default: break
                }
                
                guard let error = error as? NetworkServiceError else {
                    imageUploadManager.responseFail(willContinue: true)
                    return
                }
                imageUploadManager.responseFail(willContinue: false)
            }
        }
    }
}
