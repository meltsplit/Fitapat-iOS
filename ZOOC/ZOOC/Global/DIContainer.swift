//
//  DIContainer.swift
//  ZOOC
//
//  Created by 장석우 on 11/22/23.
//

import Foundation
import PhotosUI

final class DIContainer {
    
    static let shared = DIContainer()
    private init() {}
 
}

    
extension DIContainer {
    
    func makeUploadingToastController() -> UploadingToastController {
        let utc = UploadingToastController()
        ImageUploadManager.shared.delegate = utc
        return utc
    }
    
    func makeWebVC(
        url: String
    ) -> FapWebViewController {
        let rs = ReissueAPIService()
        let vm = FapWebViewModel(url: url, refreshService: rs)
        let vc = FapWebViewController(viewModel: vm)
        return vc
    }
    
    func makeFapWebVC(
        path: String,
        customData: MakeCharacterResult? = nil
    ) -> FapWebViewController {
        
        
        let rs = ReissueAPIService()
        let vm = FapWebViewModel(url: ExternalURL.fapWebURL + path,
                                 customData: customData,
                                 refreshService: rs)
        let vc = FapWebViewController(viewModel: vm)
        return vc
    }
    
    func makeFapWebVC(url: String) -> FapWebViewController {
        
        
        let rs = ReissueAPIService()
        let vm = FapWebViewModel(url: url,
                                 refreshService: rs)
        let vc = FapWebViewController(viewModel: vm)
        return vc
    }
        
    //MARK: - Splash Scene
    
    func makeSplashVC(_ userInfo: UserInfoDict?) -> SplashViewController {
        let userService = DefaultUserService()
        let realmService = DefaultRealmService()
        let frcService = DefaultFirebaseRemoteConfigService()
        let riService = ReissueAPIService()
        
        let ur = DefaultUserRepository(userService: userService, realmService: realmService)
        let ar = DefaultAppRepository(frcService: frcService)
        
        let uc = DefaultSplashUseCase(
            userRepository: ur,
            appRepository: ar,
            reissueService: riService
        )
        
        let vm = SplashViewModel(useCase: uc, userInfo: userInfo)
        let vc = SplashViewController(viewModel: vm)
        
        return vc
    }

    //MARK: - Tab Scene
    
    func makeTabBarController() -> FapTabBarController {
        return FapTabBarController()
    }
    
    //MARK: - Custom Scene
    
    func makeChooseConceptVC() -> ChooseConceptViewController {
        let us = DefaultUserService()
        let rs = DefaultRealmService()
        let cs = DefaultCustomService(); let tcs = TestCustomService()
        
        let cr = DefaultCustomRepository(customService: cs)
        let ur = DefaultUserRepository(userService: us, realmService: rs)
        
        let vm = ChooseConceptViewModel(customRepository: cr,
                                        userRepository: ur
        )
        let vc = ChooseConceptViewController(viewModel: vm)
        return vc
    }
    
    func makeCustomVC() -> CustomViewController {
        
        let vc = CustomViewController(
            viewType: .concept,
            viewModel: CustomViewModel(
                useCase: DefaultCustomUseCase(
                    userRepository: DefaultUserRepository(
                        userService: DefaultUserService(),
                        realmService: DefaultRealmService()
                    ),
                    customRepository: DefaultCustomRepository(
                        customService: DefaultCustomService()
                    )
                )
            )
        )
        
        return vc
    }
    
    func makeCustomDetailVC(
        detailType: CustomType,
        id: Int) -> CustomDetailViewController {
            
        let cs = DefaultCustomService()
        let us = DefaultUserService()
        let rs = DefaultRealmService()
        
        let cr = DefaultCustomRepository(customService: cs)
        let ur = DefaultUserRepository(
            userService: us,
            realmService: rs
        )
        
        let usecase = DefaultCustomDetailUseCase(
            characterID: id,
            customRepository: cr,
            userRepository: ur
        )
        
        let vm = CustomDetailViewModel(usecase: usecase)
        
        let vc = CustomDetailViewController(
            detailType: detailType,
            viewModel: vm
        )
        return vc
    }
    
    func makeMainCustomVC(
        _ concept: CustomConceptResult,
        _ keywordsPrompt: [CustomKeywordType : PromptDTO?]?
    ) -> CustomMainViewController {
        
        let cs = DefaultCustomService(); let tcs = TestCustomService()
        
        let pr = DefaultPetRepository.shared
        let cr = DefaultCustomRepository(customService: cs)
        
        let vm = CustomMainViewModel(petRepository: pr,
                                           customRepository: cr,
                                           concept: concept, 
                                           keywordsPrompt: keywordsPrompt)
        
        let vc = CustomMainViewController(viewModel: vm)
        vc.title = concept.name + " " + String(localized: "컨셉")
        return vc
    }
    
    func makeCustomVirtualResultVC(_ data: MakeCharacterResult) -> CustomVirtualResultViewController {
        
        let cs = DefaultCustomService()
        let ss = DefaultShopService()
        
        let pr = DefaultPetRepository.shared
        let cr = DefaultCustomRepository(customService: cs)
        let sr = DefaultShopRepository(shopService: ss)
        
        let vm = CustomVirtualResultViewModel(petRepository: pr,
                                              customRepository: cr,
                                              shopRepository: sr,
                                              initData: data)
        
        let vc = CustomVirtualResultViewController(viewModel: vm)
        return vc
    }
    
    //MARK: - GenAI Scene
    
    func makeGenAIGuideVC(
        name: String,
        breed: String?,
        retryWithPet: PetResult? = nil
    ) -> GenAIGuideViewController {
        
        let usecase = DefaultGenAIGuideUseCase(name: name,
                                               breed: breed)
        let vm = GenAIGuideViewModel(genAIGuideUseCase: usecase)
        let vc = GenAIGuideViewController(viewModel: vm, retryWithPet: retryWithPet)
        return vc
    }
    
    func makeGenAISelectImageViewController(
        name: String,
        breed: String?,
        imagesResult: [PHPickerResult],
        retryWithPet: PetResult? = nil
    ) -> GenAISelectImageViewController {
        
        let petRepo = DefaultPetRepository.shared
        
        let usecase = DefaultGenAISelectImageUseCase(
            name: name,
            breed: breed,
            selectedImageDatesets: imagesResult,
            repository: petRepo,
            imageUploadManager: ImageUploadManager.shared
        )
        
        let vm = GenAISelectImageViewModel(genAISelectImageUseCase: usecase, retryWithPet: retryWithPet)
        let vc = GenAISelectImageViewController(viewModel: vm)
        
        return vc
    }

    
    //MARK: - Onboarding Scene
    
    func makeLoginVC() -> OnboardingLoginViewController {

        let authService = DefaultAuthService()
        let userService = DefaultUserService()
        let realmService = DefaultRealmService()
        let senService = DefaultSimpleEasyNotificationService()
        
        let authRepo = DefaultAuthRepository(
            authService: authService,
            realmService: realmService,
            senService: senService
        ) { oauthProviderType in
            let oauthService = oauthProviderType.service
            return oauthService
        }
        
        let userRepo = DefaultUserRepository(
            userService: userService,
            realmService: realmService
        )
        
        let usecase = DefaultOnboardingLoginUseCase(
            authRepository: authRepo, 
            userRepository: userRepo
        )
        
        let vm = OnboardingLoginViewModel(useCase: usecase)
        let vc = OnboardingLoginViewController(viewModel: vm)
        return vc
    }
    
    func makeAgreementVC(_ manager: OnboardingStateManager, _ model: OnboardingUserInfo) -> OnboardingAgreementViewController {
        
        let authService = DefaultAuthService()
        let userService = DefaultUserService()
        let realmService = DefaultRealmService()
        let senService = DefaultSimpleEasyNotificationService()
        
        let authRepo = DefaultAuthRepository(
            authService: authService,
            realmService: realmService,
            senService: senService
        ) { oauthProviderType in
            let oauthService = oauthProviderType.service
            return oauthService
        }
        
        let userRepo = DefaultUserRepository(
            userService: userService,
            realmService: realmService
        )
        
        let uc = DefaultOnboardingAgreementUseCase(
            authRepository: authRepo,
            userRepository: userRepo
        )
        
        let vm = OnboardingAgreementViewModel(useCase: uc, manager: manager, model: model)
        let vc = OnboardingAgreementViewController(viewModel: vm)
        return vc
    }
    
    func makeNameVC(_ manager: OnboardingStateManager, _ model: OnboardingUserInfo) -> OnboardingNameViewController {
        let `as` = DefaultAuthService()
        let us = DefaultUserService()
        let rs = DefaultRealmService()
        let ss = DefaultSimpleEasyNotificationService()
        
        let ar = DefaultAuthRepository(
            authService: `as`,
            realmService: rs,
            senService: ss
        ) { oauthProviderType in
            let oauthService = oauthProviderType.service
            return oauthService
        }
        
        let ur = DefaultUserRepository(
            userService: us,
            realmService: rs
        )
        
        let uc = DefaultOnboardingNameUseCase(
            userRepository: ur,
            authRepository: ar
        )
        
        let vm = OnboardingNameViewModel(useCase: uc, manager: manager, model: model)
        let vc = OnboardingNameViewController(viewModel: vm)
        return vc
    }
    
    func makePhoneVerificationVC(_ manager: OnboardingStateManager, _ model: OnboardingUserInfo) -> OnboardingPhoneVerificationViewController {
        let `as` = DefaultAuthService()
        let us = DefaultUserService()
        let rs = DefaultRealmService()
        let ss = DefaultSimpleEasyNotificationService()
        
        let ar = DefaultAuthRepository(
            authService: `as`,
            realmService: rs,
            senService: ss
        ) { oauthProviderType in
            let oauthService = oauthProviderType.service
            return oauthService
        }
        
        let ur = DefaultUserRepository(
            userService: us,
            realmService: rs
        )
        
        let uc = DefaultOnboardingPhoneVerificationUseCase(
            userRepository: ur,
            authRepository: ar
        )
        
        let vm = OnboardingPhoneVerificationViewModel(useCase: uc, manager: manager, model: model)
        let vc = OnboardingPhoneVerificationViewController(viewModel: vm)
        return vc
    }
    
    //MARK: MY Scene
    
    func makeMyVC() -> MyViewController {
        
        
        let authService = DefaultAuthService()
        let userService = DefaultUserService()
        let realmService = DefaultRealmService()
        let senService = DefaultSimpleEasyNotificationService()
        
        let authRepo = DefaultAuthRepository(
            authService: authService,
            realmService: realmService,
            senService: senService
        ) { oauthProviderType in
            let oauthService = oauthProviderType.service
            return oauthService
        }
        
        let userRepo = DefaultUserRepository(
            userService: userService,
            realmService: realmService
        )
        
        let usecase = DefaultMyUseCase(
            petRepository: DefaultPetRepository.shared,
            authRepository: authRepo,
            userRepository: userRepo
        )
        
        let vm = MyViewModel(myUseCase: usecase)
        let vc = MyViewController(viewModel: vm)
        return vc
    }
}
