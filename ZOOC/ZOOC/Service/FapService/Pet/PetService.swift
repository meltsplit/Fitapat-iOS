//
//  PetService.swift
//  ZOOC
//
//  Created by 장석우 on 11/21/23.
//
import Foundation

import Moya
import RxMoya
import RxSwift

protocol PetService {
    typealias ImageUploadManagerProtocol = ImageManagerSettable & URLSessionTaskDelegate
    
    func getPet() -> Single<PetResult>
    func patchPet(_ request: EditProfileRequest) -> Single<PetResult>
    func registerPet(_ request: MyRegisterPetRequest) -> Single<PetResult>
    
    func postMakeDataset(_ petID: Int) -> Single<GenAIDatasetResult>
    func getDatasetInfo(_ petID: Int) -> Single<PetDatasetInformationResult>
    func postPetImages(datasetID: String, files: [Data], with manager: ImageUploadManagerProtocol) async throws -> SimpleResponse
}

final class DefaultPetService: NSObject, Networking {  //TODO: struct로 해도 되나? class 말고 struct로 했을 때 부작용 뭐가 있지
    
    private var provider = MoyaProvider<PetTargetType>(session: Session(interceptor: FapInterceptor.shared),
                                                       plugins: [MoyaLoggingPlugin()])
    
    private var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default,
                                                    delegate: nil,
                                                    delegateQueue: nil)
    
}

extension DefaultPetService: PetService {
    
    func getPet() -> Single<PetResult> {
        provider.rx.request(.getPet)
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(PetResult.self)
    }
    
    func patchPet(_ request: EditProfileRequest) -> Single<PetResult> {
        provider.rx.request(.patchPet(request: request))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(PetResult.self)
    }
    
    func registerPet(_ request: MyRegisterPetRequest) -> Single<PetResult> {
        provider.rx.request(.postRegisterPet(request))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(PetResult.self)
    }
    
    func getDatasetInfo(_ petID: Int) -> Single<PetDatasetInformationResult> {
        provider.rx.request(.getPetDatasetInfo(petID))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(PetDatasetInformationResult.self)
    }
    
    func postMakeDataset(_ petID: Int) -> Single<GenAIDatasetResult> {
        provider.rx.request(.postDataset(petID))
            .filterSuccessfulStatusCodes()
            .mapGenericResponse(GenAIDatasetResult.self)
    }
    
    func postPetImages(datasetID: String, 
                       files: [Data],
                       with manager: ImageUploadManagerProtocol) async throws -> SimpleResponse {
        
        let body = makeMultipartFormImageBody(keyName: "files", images: files)
        
        let request = try makeHTTPRequest(method: .patch,
                                          path: "/ai/images/\(datasetID)",
                                          headers: APIConstants.multipartHeaderWithBoundary, 
                                          body: nil)
        
   
        manager.setRequest(request, with: body)

        let (data, response) = try await urlSession.upload(for: request,
                                                           from: body,
                                                           delegate: manager)
    
        return try validataDataResponse(data, response: response, to: SimpleResponse.self)
    }
    
}
