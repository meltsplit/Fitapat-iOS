//
//  GenAISelectImageViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import RxSwift
import RxCocoa

final class GenAISelectImageViewController : BaseViewController {
    
    //MARK: - Properties
    
    let viewModel: GenAISelectImageViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    let rootView = GenAISelectImageView()
    
    let xButton = UIBarButtonItem(image: .zwImage(.ic_exit),
                                  style: .plain,
                                  target: nil,
                                  action: nil)
    
    //MARK: - Life Cycle
    
    init(viewModel: GenAISelectImageViewModel) {
        self.viewModel = viewModel
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
        
        setNavigationBar()
        bindUI()
        bindViewModel()
    }
    
    //MARK: - Custom Method
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem.fixedSpace(10),
                                              xButton]
    }
    
    func bindUI() {
        xButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.presentAlertViewController()
            }
            .disposed(by: disposeBag)
        
        rootView.reSelectedImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                NotificationCenter.default.post(
                    name: Notification.Name("reselectImage"),
                    object: nil
                )
                owner.navigationController?.popViewController(animated: false)
            }).disposed(by: disposeBag)
        
        rootView.generateAIModelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.rootView.generateAIModelButton.isEnabled = false
                owner.rootView.generateAIModelButton.setTitle("", for: .normal)
                owner.rootView.buttonActivityIndicatorView.startAnimating()
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let input = GenAISelectImageViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear.asObservable(),
            generateAIModelButtonDidTapEvent: self.rootView.generateAIModelButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.petImageDatasets.bind(to: self.rootView.petImageCollectionView.rx.items(
            cellIdentifier: GenAIPetImageCollectionViewCell.cellIdentifier,
            cellType: GenAIPetImageCollectionViewCell.self
        )) { index, _, cell in
            if !output.petImageDatasets.value.isEmpty {
                cell.petImageView.image = output.petImageDatasets.value[index]
            }
        }.disposed(by: self.disposeBag)
        
        output.ableToShowImages
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, canShow in
                if canShow {
                    owner.rootView.activityIndicatorView.stopAnimating()
                    owner.rootView.generateAIModelButton.isEnabled = true
                    owner.rootView.petImageCollectionView.reloadData()
                } else {
                    owner.rootView.activityIndicatorView.startAnimating()
                }
            }).disposed(by: disposeBag)
        
        output.showToast
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, message in
                owner.presentToast(message)
            }).disposed(by: disposeBag)
        
        output.imageUploadDidBegin.subscribe(with: self, onNext: { owner, uploadCompleted in
            if uploadCompleted {
                owner.rootView.buttonActivityIndicatorView.stopAnimating()
                owner.dismiss(animated: true)
                owner.navigationController?.popToRootViewController(animated: true)
            }
            else { owner.showToast("AI 모델 생성 중 문제가 발생했습니다") }
        }).disposed(by: disposeBag)
    }
}

extension GenAISelectImageViewController {
    func presentAlertViewController() {
        let alertVC = FapAlertViewController(.leaveAIPage)
        alertVC.delegate = self
        self.present(alertVC, animated: false)
    }
}

extension GenAISelectImageViewController: FapAlertViewControllerDelegate {
    func leftButtonDidTap(_ alertType: FapAlertType) {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func rightButtonDidTap(_ alertType: FapAlertType) {
        return
    }
}
