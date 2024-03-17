//
//  PetRepository.swift
//  ZOOC
//
//  Created by 장석우 on 11/18/23.
//

import UIKit

import RxSwift
import Moya

//MARK: API 명세서 중 Route가 Pet인 데이터 대한 저장소 입니다.

enum PetError: Error {
    case noPet
}

protocol PetRepository {
    typealias ImageUploadManagerProtocol = ImageManagerSettable & URLSessionTaskDelegate
    
    var petResult: PetResult? { get set }
    var petInfo: PetDatasetInformationResult? { get set}
    
    func getPet() -> Observable<PetResult>
    func patchPet(_ request: EditProfileRequest) -> Observable<Bool>
    func registerPet(_ reqeust: MyRegisterPetRequest) -> Observable<PetResult>
    
    
    func getDatasetInfo(_ petID: Int) -> Observable<PetDatasetInformationResult>
    
    func postPetImages(datasetID: String,
                       files: [UIImage],
                       with manager: ImageUploadManagerProtocol) async throws -> SimpleResponse
    func postMakeDataset(_ petId: Int) -> Observable<GenAIDatasetResult>
    
    func updatePetInfo()
}


final class DefaultPetRepository {
    
    //MARK: - Dependency

    private let petService: PetService
    static let shared = DefaultPetRepository(petService: DefaultPetService())
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()

    var petResult: PetResult?
    var petInfo: PetDatasetInformationResult?
   
    
    //MARK: - Life Cycle

    private init(petService: PetService) {
        self.petService = petService
        
        updatePet()
    }
    
    func reset() {
        petResult = nil
        petInfo = nil
    }
}

//MARK: - Pet Repository

extension DefaultPetRepository: PetRepository {
    
    func getPet() -> Observable<PetResult> {
        petService.getPet()
            .do(onSuccess: { [weak self] in self?.petResult = $0 } )
            .do(onError: { _ in print("🙏🙏🙏404 여기에 잡히나?🙏🙏🙏🙏🙏")})
            .asObservable()
            .catch { error in
                guard let error = error as? MoyaError,
                      error.response?.statusCode == 404
                else { return Observable.error(error) }
                
                return Observable.error(PetError.noPet)
            }
    }
    
    func patchPet(_ request: EditProfileRequest) -> Observable<Bool>  {
        petService.patchPet(request)
            .map { _ in true }
            .asObservable()
    }
    
    func registerPet(_ request: MyRegisterPetRequest) -> Observable<PetResult> {
        petService.registerPet(request)
            .do(onSuccess: { [weak self] in self?.petResult = $0})
            .asObservable()
    }
    
    func getDatasetInfo(_ petID: Int) -> Observable<PetDatasetInformationResult> {
        petService.getDatasetInfo(petID)
            .do(onSuccess: { [weak self] in self?.petInfo = $0 })
            .asObservable()
    }
    
    func postPetImages(datasetID: String,
                       files: [UIImage],
                       with manager: ImageUploadManagerProtocol) async throws  -> SimpleResponse {
        let data = files.map {
            $0.jpegData(compressionQuality: 0.99) ?? Data()
        }
        
        return try await petService.postPetImages(datasetID: datasetID, files: data, with: manager)
    }
    
    func postMakeDataset(_ petId: Int) -> Observable<GenAIDatasetResult> {
        petService.postMakeDataset(petId)
            .do(onSuccess: { [weak self] in self?.petResult?.datasetID = $0.datasetId })
            .asObservable()
    }
    
    func updatePet() {
        getPet()
            .map { $0.id }
            .concatMap(getDatasetInfo)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func updatePetInfo() {
        guard let petID = petResult?.id else { return }
        getDatasetInfo(petID)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}
