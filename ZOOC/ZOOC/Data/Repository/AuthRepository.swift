//
//  UserRepository.swift
//  ZOOC
//
//  Created by 장석우 on 11/18/23.
//

import Foundation

import RxSwift
import Moya

protocol AuthRepository {
    func sendVerificationMessage(to phoneNumber: [String], code: String) -> Observable<Void>
    func authorize(_ serviceType: OAuthProviderType) -> Observable<OAuthAuthenticationModel>
    func userCheck(_ oauthModel: OAuthAuthenticationModel) -> Observable<OnboardingUserInfo>
    func login(_ oauthModel: OAuthAuthenticationModel) -> Observable<FitapatAuthenticationResult>
    func signUp(_ model: OnboardingUserInfo) -> Observable<FitapatAuthenticationResult> 
    func saveJWTTokens(_ result: FitapatAuthenticationResult)
    
}

final class DefaultAuthRepository {
    
    //MARK: - Dependency
    
    private let authService: AuthService
    private let realmService: RealmService
    private let senService: SimpleEasyNotificationService
    private let factory: (OAuthProviderType) -> OAuthServiceType
    
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    init(
        authService: AuthService,
        realmService: RealmService,
        senService: SimpleEasyNotificationService,
        factory: @escaping (OAuthProviderType) -> OAuthServiceType
    ) {
        self.authService = authService
        self.realmService = realmService
        self.senService = senService
        self.factory = factory
    }
    
}

extension DefaultAuthRepository: AuthRepository {
    
    func sendVerificationMessage(to phoneNumber: [String], code: String) -> RxSwift.Observable<Void> {
        senService.sendMessage(.init(code: code, to: phoneNumber))
            .asObservable()
    }
    
    func authorize(_ serviceType: OAuthProviderType) -> Observable<OAuthAuthenticationModel> {
        return factory(serviceType).authorize().asObservable()
    }
    
    func userCheck(_ oauthModel: OAuthAuthenticationModel) -> Observable<OnboardingUserInfo> {
        return authService.userCheck(
            "Bearer \(oauthModel.oauthToken)",
            oauthModel.oauthType.rawValue
        )
        .asObservable()
        .map{ $0.toDomain(false, oauthModel)}
        .catch { error in
            guard let error = error as? MoyaError else { return .error(AuthError.unknown("유저 확인 실패"))}
            guard error.response?.statusCode == 404 else { return .error(AuthError.unknown("유저 확인 실패"))}
            let entity = OnboardingUserInfo(
                isFirstUser: true,
                oauthModel: oauthModel,
                userInfo: .init(phone: nil, name: nil, marketing: nil))
            return .just(entity)
        }
    }
    
    func login(_ oauthModel: OAuthAuthenticationModel) -> Observable<FitapatAuthenticationResult> {
        return authService.login(
            "Bearer \(oauthModel.oauthToken)",
            oauthModel.oauthType.rawValue
        ).asObservable()
    }
    
    func signUp(_ model: OnboardingUserInfo) -> Observable<FitapatAuthenticationResult> {
        return authService.signUp(
            model.oauthModel.oauthType.rawValue,
            "Bearer \(model.oauthModel.oauthToken)",
            model.userInfo.toData()
        ).asObservable()
    }
    
    func saveJWTTokens(_ result: FitapatAuthenticationResult) {
        UserDefaultsManager.zoocAccessToken = result.accessToken
        UserDefaultsManager.zoocRefreshToken = result.refreshToken
    }
}
