//
//  MyViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MyViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: MyViewModel
    private let disposeBag = DisposeBag()
    
    private let deleteAccountSubject = PublishSubject<Void>()
    
    init(viewModel: MyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Components
    
    private lazy var rootView = MyView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        self.rx.viewWillAppear
            .subscribe(with: self, onNext: { owner, _ in
                //owner.navigationController?.isNavigationBarHidden = true
            }).disposed(by: disposeBag)
        
        rootView.profileView.editProfileButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToEditProfileView()
            }).disposed(by: disposeBag)
        
        rootView.noProfileView.registerPetButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.pushToRegisterPetView()
            }).disposed(by: disposeBag)
        
        rootView.deleteAccountButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentDeleteAccountZoocAlertView()
            }).disposed(by: disposeBag)
        
        rootView.settingView.rx.itemSelected.subscribe(with: self, onNext: { owner, index in
            switch index.row {
            case 0: owner.pushToOrderHistoryView()
            case 1: owner.pushToNoticeSettingView()
            case 2:
                let url = ExternalURL.fapInstagram
                let webVC = DIContainer.shared.makeWebVC(url: url)
                owner.present(webVC,animated: true)
            case 3:
                let url = ExternalURL.fapChannelTalk
                let webVC = DIContainer.shared.makeWebVC(url: url)
                owner.present(webVC,animated: true)
            case 4: owner.pushToAppInformationView()
            default:
                break
            }
        }).disposed(by: disposeBag)
        
    }
    private func bindViewModel() {
        let input = MyViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            logoutButtonDidTapEvent: self.rootView.settingView.rx.itemSelected.asObservable()
                .filter({ $0.item == 5 }),
            deleteAccountButtonDidTapEvent: deleteAccountSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.profileData
            .asDriver(onErrorJustReturn: PetResult())
            .drive(with: self, onNext: { owner, profile in
                owner.rootView.updateUI(profile)
            }).disposed(by: disposeBag)
        
        output.logoutSuccess
            .asDriver(onErrorJustReturn: Bool())
            .filter { $0 }
            .drive(with: self, onNext: { owner, _ in
                let onboardingNVC = UINavigationController(
                    rootViewController: DIContainer.shared.makeLoginVC()
                )
                UIApplication.shared.changeRootViewController(onboardingNVC)
            }).disposed(by: disposeBag)
        
        output.deleteAccountSuccess
            .asDriver(onErrorJustReturn: Bool())
            .filter { $0 }
            .drive(with: self, onNext: { owner, isDeleted in
                let onboardingNVC = UINavigationController(
                    rootViewController: DIContainer.shared.makeLoginVC()
                )
                UIApplication.shared.changeRootViewController(onboardingNVC)
            }).disposed(by: disposeBag)
    }
}

//MARK: Flow Login
extension MyViewController {
    
    private func pushToOrderHistoryView() {
        let webVC = DIContainer.shared.makeFapWebVC(path: "/mypage/orderlist")
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    private func pushToEditProfileView() {
        let editProfileVC = MyEditProfileViewController(
            viewModel: MyEditProfileViewModel(
                myEditProfileUseCase: DefaultMyEditProfileUseCase(
                    petRepository: DefaultPetRepository.shared
                )
            )
        )
        editProfileVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func pushToAppInformationView() {
        let appInformationVC = MyAppInformationViewController()
        appInformationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(appInformationVC, animated: true)
    }
    
    private func pushToNoticeSettingView() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    private func pushToRegisterPetView() {
        let registerPetVC = MyRegisterPetViewController(
            petRepository: DefaultPetRepository.shared
        )
        registerPetVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(registerPetVC, animated: true)
    }
    
    private func presentDeleteAccountZoocAlertView() {
        let zoocAlertVC = FapAlertViewController(.deleteAccount)
        zoocAlertVC.delegate = self
        present(zoocAlertVC, animated: false)
    }
}


extension MyViewController: FapAlertViewControllerDelegate {
    func leftButtonDidTap(_ alertType: FapAlertType) {
        deleteAccountSubject.onNext(())
    }
    
    func rightButtonDidTap(_ alertType: FapAlertType) {
        self.dismiss(animated: true)
    }
}



//
//extension MyViewController: MFMailComposeViewControllerDelegate {
//    private func sendMail(subject: String, body: String) {
//        if MFMailComposeViewController.canSendMail() {
//            let composeViewController = MFMailComposeViewController()
//            composeViewController.mailComposeDelegate = self
//
//
//            composeViewController.setToRecipients(["zooc0102@gmail.com"])
//            composeViewController.setSubject(subject)
//            composeViewController.setMessageBody(body, isHTML: false)
//
//            self.present(composeViewController, animated: true, completion: nil)
//        } else {
//            print("메일 보내기 실패")
//            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패",
//                                                       message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
//                                                       preferredStyle: .alert)
//            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
//                // 앱스토어로 이동하기(Mail)
//                let url = "https://apps.apple.com/kr/app/mail/id1108187098"
//                self.presentSafariViewController(url)
//            }
//            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
//
//            sendMailErrorAlert.addAction(goAppStoreAction)
//            sendMailErrorAlert.addAction(cancleAction)
//            self.present(sendMailErrorAlert, animated: true, completion: nil)
//        }
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        switch result {
//        case .cancelled:
//            showToast("메일 보내기가 취소되었습니다.", type: .normal)
//        case .sent:
//            showToast("메일이 성공적으로 보내졌습니다.", type: .good)
//        case .saved:
//            showToast("메일이 저장되었습니다.", type: .normal)
//        case .failed:
//            showToast("메일 보내기에 오류가 발생했습니다.", type: .normal)
//        default:
//            break
//        }
//        controller.dismiss(animated: true, completion: nil)
//    }
//}
