//
//  UploadingToastController.swift
//  ZOOC
//
//  Created by 장석우 on 11/27/23.
//

import UIKit

import RxSwift
import RxCocoa

final class UploadingToastController: NSObject {
    
    //MARK: - UI Components
    
    private let uploadingToast = UploadingToast()
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override init() {
        super.init()
        
        setUploadingToast()
        bindUI()
    }
    
    //MARK: - Private Methods
    
    private func setUploadingToast() {
        guard let window = UIApplication.shared.firstWindow else { return }
        window.addSubview(uploadingToast)
        
        uploadingToast.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(window.safeAreaInsets.bottom + 90)
        }
        window.bringSubviewToFront(uploadingToast)
    }
    
    private func bindUI() {
        uploadingToast.xButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                Haptic.impact(.light).run()
                UIView.animate(withDuration: 0.7,
                               animations: { owner.uploadingToast.alpha = 0 })
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - ImageUploadProgressDelegate

extension UploadingToastController: ImageUploadProgressDelegate {
    
    func progressTaskDidCreate() {
        Task { @MainActor in
            let window = UIApplication.shared.firstWindow
            window?.bringSubviewToFront(uploadingToast)
            uploadingToast.updateUI(.willStart, progress: 0)
            uploadingToast.alpha = 1
        }
    }
    
    func progressTaskIsProcessing(with ratio: Float) {
        Task { @MainActor in
            uploadingToast.updateUI(.uploading, progress: ratio)
        }
    }
    
    func progressTaskCompleted() {
        Task { @MainActor in
            uploadingToast.updateUI(.modeling)
        }
    }
}


extension UploadingToastController: ImageUploadResponseDelegate {
    
    func responseSuccess() {
        Task { @MainActor in
            uploadingToast.updateUI(.done)
            UIView.animate(withDuration: 0.7, delay: 2) {
                self.uploadingToast.alpha = 0
            }
        }
    }
    
    func responseFail(willContinue: Bool) {
 
        Task { @MainActor in
            guard willContinue else {
                uploadingToast.updateUI(.fail)
                return
            }
            uploadingToast.alpha = 0
        }
        
        
    }
    
}


extension UploadingToastController: ImageUploadExceptionDelegate {
    
    func didEnterBackground(_ status: UploadStatus) {
        Task { @MainActor in
            switch status {
            case .uploading:
                uploadingToast.updateUI(.modeling)
            case .modeling:
                uploadingToast.alpha = 0
            case .none:
                break
            }
        }
  
    }
    
    func willTerminate(_ status: UploadStatus) {
        Task { @MainActor in
            uploadingToast.alpha = 0
        }
        
    }
    
}
