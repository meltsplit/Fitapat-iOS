//
//  UserRepository.swift
//  ZOOC
//
//  Created by 류희재 on 1/12/24.
//

import Foundation

import RxSwift
import WebKit


protocol UserRepository {
    func updateFCMToken() -> Observable<Void>
    func updateUser(_ request: UserInfoRequest) -> Observable<Void>
    func getTicket() -> Observable<Int>
    func logout() -> Observable<Bool>
    func deleteAccount() -> Observable<Bool>
}

final class DefaultUserRepository {
    
    //MARK: - Dependency
    
    private let userService: UserService
    private let realmService: RealmService
    
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    init(
        userService: UserService,
        realmService: RealmService
    ) {
        self.userService = userService
        self.realmService = realmService
    }

}

extension DefaultUserRepository: UserRepository {
    
    func updateFCMToken() -> Observable<Void> {
        userService.putFCMToken(UserDefaultsManager.fcmToken)
            .map{ _ in () }
            .asObservable()
    }
    
    func updateUser(_ request: UserInfoRequest) -> Observable<Void> {
        userService.patchUser(request)
            .map { _ in }
            .asObservable()
    }
    
    func getTicket() -> Observable<Int> {
        userService.getTicket()
            .asObservable()
    }
    
    func logout() -> Observable<Bool> {
        userService.logout()
            .do(onSuccess: { [weak self] _ in
                self?.resetUserInfo()
            }).asObservable()
    }
    
    func deleteAccount() -> Observable<Bool> {
        userService.deleteAccount()
            .do(onSuccess: { [weak self] _ in
                self?.deleteUserInfo()
            }).asObservable()
    }
    
    func resetUserInfo() {
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records
                  .forEach {
                    WKWebsiteDataStore.default()
                      .removeData(
                        ofTypes: $0.dataTypes,
                        for: [$0],
                        completionHandler: {}
                      )
                  }
              }
        
        UserDefaultsManager.reset()
        DefaultPetRepository.shared.reset()
        ImageUploadManager.shared.reset()
    }
    
    func deleteUserInfo() {
        
        WKWebsiteDataStore.default()
              .fetchDataRecords(
                ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
              ) { records in
                records
                  .forEach {
                    WKWebsiteDataStore.default()
                      .removeData(
                        ofTypes: $0.dataTypes,
                        for: [$0],
                        completionHandler: {}
                      )
                  }
              }
        
//        Task {
//            await realmService.deleteAllCartedProducts()
//            await realmService.deleteAllBasicAddress()
//        }
        
        UserDefaultsManager.reset()
        DefaultPetRepository.shared.reset()
        ImageUploadManager.shared.reset()
    }
}


