//
//  FapWebViewModel.swift
//  ZOOC
//
//  Created by 장석우 on 1/29/24.
//

import Foundation

import RxSwift
import RxRelay

final class FapWebViewModel: ViewModelType {
    
    //MARK: - Dependency
    
    private let service: ReissueAPIService
    
    //MARK: - Properties
    
    private var url: String
    private var refreshing = false
    private let customData: MakeCharacterResult?
    
    //MARK: - Input & Output
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let getMessageFromWebEvent: Observable<WebToAppMessage>
    }
    
    struct Output {
        let loadWebView = PublishRelay<String>()
        
        let backAction = PublishRelay<Void>()
        let pushWebVC = PublishRelay<String>()
        let popVC = PublishRelay<Void>()
        let popToRootVC = PublishRelay<Void>()
        let presentWebVC = PublishRelay<String>()
        let dismissVC = PublishRelay<Void>()
        let switchTab = PublishRelay<Int>()
        
        let sendEvaluateJS = PublishRelay<(JavaScriptFuncName, String)>()
        let switchToLoginVC = PublishRelay<Void>()
    }
    
    //MARK: - Life Cycle

    init(
        url: String,
        customData: MakeCharacterResult? = nil,
        refreshService: ReissueAPIService
    ) {
        self.url = url
        self.service = refreshService
        self.customData = customData
    }
    
    func transform(from input: Input, disposeBag: RxSwift.DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .map { self.url }
            .bind(to: output.loadWebView)
            .disposed(by: disposeBag)

        input.getMessageFromWebEvent
            .subscribe(with: self, 
                       onNext: { owner, message in
                switch message.name {
                case .authEvent: owner.postAccessToken(output)
                case .refreshEvent: owner.refresh(output, disposeBag)
                case .tokenExpired:
                    output.switchToLoginVC.accept(())
                case .transitionEvent: owner.transitionAction(output,
                                                              body: message.body)
                case .backEvent: output.backAction.accept(())
                case .characterEvent: owner.postCharacter(output)
                case .petEvent: 
                    print("petEvent 나야나")
                    DefaultPetRepository.shared.updatePet()
                case .unknown: print("⛔️ 일치하는 ListenerName이 없습니다")
                
                }
                
            })
            .disposed(by: disposeBag)
        
        return output
    }
}

extension FapWebViewModel {
    
    private func refresh(_ output: Output, _ disposeBag: DisposeBag) {
        print("[Web -> App] web이 refreshEvent를 요청했습니다.")
        guard !refreshing else { return }
        service.postRefreshToken()
            .subscribe(
                with: self,
                onSuccess: { owner, data in
                    UserDefaultsManager.zoocAccessToken = data.accessToken
                    UserDefaultsManager.zoocRefreshToken = data.refreshToken
                    let data = [
                        "accessToken": UserDefaultsManager.zoocAccessToken,
                        "refreshToken" : UserDefaultsManager.zoocRefreshToken
                    ]
                    
                    guard let serialData = try? JSONSerialization.data(withJSONObject: data, options: []),
                          let encodedData = String(data: serialData, encoding: .utf8) else { return  }
                    
                    output.sendEvaluateJS.accept((.getRefreshAuth, encodedData))
                    owner.refreshing = false
                },
                onFailure: { owner, error in
                    output.switchToLoginVC.accept(())
                })
            .disposed(by: disposeBag)
    }
    
    private func postAccessToken(_ output: Output) {
        
        print("[Web -> App] web이 authEvent를 요청했습니다.")
        
        let at = UserDefaultsManager.zoocAccessToken
        let rt = UserDefaultsManager.zoocRefreshToken
        
        let data = [
            "accessToken": at,
            "refreshToken" : rt
        ]
        
        guard let serialData = try? JSONSerialization.data(withJSONObject: data, options: []),
              let encodedData = String(data: serialData, encoding: .utf8) else { return  }
        
        output.sendEvaluateJS.accept((.responseToken, encodedData))
    }
    
    private func postCharacter(_ output: Output) {
        print("postCharacter🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏")
//        guard let customData else { return }
        
        let dict: [String: Any?] = [
            "id": customData?.id,
            "image" : customData?.image
        ]
        
        guard let serialData = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let encodedData = String(data: serialData, encoding: .utf8) else { return }
        
        output.sendEvaluateJS.accept((JavaScriptFuncName.responseCharacter, encodedData))
    }
    
    private func transitionAction(_ output: Output, body: String?) {
        guard let body,
              let decodedData = try? JSONDecoder().decode(TransitionEventDTO.self,
                                                          from: Data(body.utf8)) else {
            return
        }
        
        let action = TransitionAction(rawValue: decodedData.action) ?? .unknown
        switch action {
        case .PUSH:
            guard let url = decodedData.url else { return }
            output.pushWebVC.accept(url)
        case .POP: 
            output.popVC.accept(())
        case .PRESENT:
            guard let url = decodedData.url else { return }
            output.presentWebVC.accept(url)
        case .DISMISS:
            output.dismissVC.accept(())
        case .POPTOROOT:
            output.popToRootVC.accept(())
        case .SWITCHTAB:
            guard let index = decodedData.index else { return }
            output.switchTab.accept(index)
        case .unknown:
            print("TransitionAction 키 값이 일치하지 않습니다")
 
        }
        
        
    }

}
