//
//  AppRepository.swift
//  ZOOC
//
//  Created by 장석우 on 11/18/23.
//

import Foundation

import RxSwift
import RxRelay

//MARK: 앱 정보, 계좌 정보 등 앱에 관한 정보를 담고 있습니다.

enum AppError: Error {
    case frcServerErr
}

protocol AppRepository {
    func checkVersion() -> Observable<VersionState>
}

final class DefaultAppRepository: AppRepository {
    
    let frcService: FirebaseRemoteConfigService
    
    init(frcService: FirebaseRemoteConfigService) {
        self.frcService = frcService
    }
    
    func checkVersion() -> Observable<VersionState> {
        return Observable<VersionState>.create { [weak self] observer in
            guard let self else { return Disposables.create()}
            _Concurrency.Task {
                do {
                    let fapVersions = try await self.frcService.getVersion()
                    
                    let localVersion = Device.getCurrentVersion().transform()
                    let latestVersion = fapVersions.latestVersion
                    let minVersion = fapVersions.minVersion
                    
                    if localVersion < minVersion {
                        observer.onNext(.mustUpdate)
                        observer.onCompleted()
                    } else if localVersion < latestVersion {
                        observer.onNext(.recommendUpdate)
                        observer.onCompleted()
                    } else {
                        observer.onNext(.latestVersion)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(AppError.frcServerErr)
                }
            }
            return Disposables.create()
        }
    }
}
