//
//  FirebaseREmoteConfigService.swift
//  ZOOC
//
//  Created by 장석우 on 11/6/23.
//

import Foundation

import RxSwift
import FirebaseRemoteConfig

protocol FirebaseRemoteConfigService {
    typealias AppID = String
    typealias DelieveryFee = Int
    
    func getAppID() async throws -> AppID
    func getVersion() async throws -> FapVersions
    func getDeliveryFee() async throws -> DelieveryFee
    func getBankAccount() async throws -> BankAccount
}

final class DefaultFirebaseRemoteConfigService: FirebaseRemoteConfigService {
    
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings =  RemoteConfigSettings()
    
    init() {
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }

    
    func getAppID() async throws -> AppID {
        let _ = try await remoteConfig.fetchAndActivate()
        
        guard let appID = remoteConfig[FapFRCKey.iosZoocAppId.rawValue].stringValue,
              !appID.isEmpty 
        else {
            throw FapFRCError.notFoundKeyValue
        }
        
        return appID
    }
    
    func getVersion() async throws -> FapVersions {
        let _ = try await remoteConfig.fetchAndActivate()
        
        guard let latestVersion = remoteConfig[FapFRCKey.latestVersion.rawValue].stringValue,
              let minVersion = remoteConfig[FapFRCKey.minVersion.rawValue].stringValue,
              !latestVersion.isEmpty,
              !minVersion.isEmpty 
        else {
            throw FapFRCError.notFoundKeyValue
        }
        
        return FapVersions(latestVersion: latestVersion.transform(),
                           minVersion: minVersion.transform())
    }
    
    func getDeliveryFee() async throws -> DelieveryFee {
        let _ = try await remoteConfig.fetchAndActivate()
        
        let deliveryFee = remoteConfig[FapFRCKey.deliveryFee.rawValue].numberValue
        
        guard deliveryFee != 0 else {
            throw FapFRCError.notFoundKeyValue
        }
        
        return Int(truncating: deliveryFee)
    }
    
    func getBankAccount() async throws -> BankAccount {
        let _ = try await remoteConfig.fetchAndActivate()
        
        guard let holder = remoteConfig[FapFRCKey.accountHolder.rawValue].stringValue,
              let bank = remoteConfig[FapFRCKey.accountBank.rawValue].stringValue,
              let accountNumber = remoteConfig[FapFRCKey.accountNumber.rawValue].stringValue,
              let accountNumberWithHyphen = remoteConfig[FapFRCKey.accountNumberWithHyphen.rawValue].stringValue,
              !holder.isEmpty,
              !bank.isEmpty,
              !accountNumber.isEmpty,
              !accountNumberWithHyphen.isEmpty
        else  {
            throw FapFRCError.notFoundKeyValue
        }
        
        return BankAccount(holder: holder,
                           bank: bank,
                           accountNumber: accountNumber,
                           accountNumberWithHyphen: accountNumberWithHyphen)
    }
}
