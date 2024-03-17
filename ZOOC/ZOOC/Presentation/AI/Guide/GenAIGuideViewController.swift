//
//  GenAIGuideViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/15.
//

import UIKit
import PhotosUI

import RxSwift
import RxCocoa

final class GenAIGuideViewController : BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let pickedImageSubject = PublishSubject<[PHPickerResult]>()
    private let viewModel: GenAIGuideViewModel
    
    private var retryWithPet: PetResult? // 진짜 미안 ㅋㅋㅋㅋ 미안해~~ 뷰컨에 그냥 프로퍼티 박아버리기~ 아니 진짜 지금 새벽 6시야....진짜로..미안...!!!! 이게 마지막 미안해
    
    //MARK: - UI Components
    
    let rootView = GenAIGuideView()
    
    
    let xButton = UIBarButtonItem(image: .zwImage(.ic_exit),
                                  style: .plain,
                                  target: nil,
                                  action: nil)
    
    //MARK: - Life Cycle
    
    init(viewModel: GenAIGuideViewModel,
         retryWithPet: PetResult? = nil) {
        self.viewModel = viewModel
        self.retryWithPet = retryWithPet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        bindViewModel()
        
        setNotification()
        setNavigationBar()
    }
    
    //MARK: - Custom Method
    
    private func bindUI() {
        self.rx.viewWillAppear.subscribe(with: self, onNext: { owner, _ in
            owner.updateUI()
        }).disposed(by: disposeBag)
        
        xButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentLeavePageAlertVC()
            }).disposed(by: disposeBag)
        
        rootView.selectImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentPHPickerViewController()
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = GenAIGuideViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            viewWillDisappearEvent: self.rx.viewWillDisappear.asObservable(),
            didFinishPickingImageEvent: pickedImageSubject.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.ableToPhotoUpload
            .subscribe(with: self, onNext: { owner, canUpload in
                guard let canUpload = canUpload else { return }
                if canUpload { owner.pushToGenAISelectImageVC(option: owner.retryWithPet)}
                else { owner.presentDenineGenerateAIViewController() }
            }).disposed(by: disposeBag)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reselectImage),
            name: Notification.Name("reselectImage"),
            object: nil
        )
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem.fixedSpace(10),
                                              xButton]
    }
    
    @objc func reselectImage() {
        presentPHPickerViewController()
    }
}

extension GenAIGuideViewController {
    private func updateUI() {
        for subview in rootView.deprecatedView.arrangedSubviews {
            rootView.deprecatedView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        (0..<GenAIGuideModel.data.count).enumerated().map { index , _ in
            let deprecatedView = GenAIDeprecatedView()
            deprecatedView.dataBind(GenAIGuideModel.data[index])
            return deprecatedView
        }.forEach(rootView.deprecatedView.addArrangedSubview)
    }
    
    private func pushToGenAISelectImageVC(option retryWithPet: PetResult?) {
        let genAISelectImageVC = DIContainer.shared.makeGenAISelectImageViewController(
            name: viewModel.getName(),
            breed: viewModel.getBreed(),
            imagesResult: viewModel.getSelectedImageDatasets(),
            retryWithPet: retryWithPet)
        self.navigationController?.pushViewController(genAISelectImageVC, animated: true)
    }
    
    private func presentPHPickerViewController() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 15
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    private func presentLeavePageAlertVC() {
        let alertVC = FapAlertViewController(.leaveRegisterPage)
        alertVC.delegate = self
        present(alertVC, animated: false)
    }
    
    private func presentDenineGenerateAIViewController() {
        let alertVC = FapAlertViewController(.notEnoughImage)
        alertVC.delegate = self
        self.present(alertVC, animated: false, completion: nil)
    }
}

extension GenAIGuideViewController: FapAlertViewControllerDelegate {
    func leftButtonDidTap(_ alertType: FapAlertType) {
        switch alertType {
        case .notEnoughImage:
            break
        case .leaveRegisterPage:
            dismiss(animated: true)
            navigationController?.popToRootViewController(animated: true)
        default:
            return
        }

    }
    
    func rightButtonDidTap(_ alertType: FapAlertType) {
        switch alertType {
        case .notEnoughImage:
            presentPHPickerViewController()
        case .leaveRegisterPage:
            return
        default:
            return
        }
    }
}


extension GenAIGuideViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        pickedImageSubject.onNext(results)
    }
}
