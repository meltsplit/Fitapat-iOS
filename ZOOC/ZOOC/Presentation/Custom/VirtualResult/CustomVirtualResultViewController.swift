//
//  CustomResultViewController.swift
//  ZOOC
//
//  Created by 류희재 on 12/16/23.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import Then

final class CustomVirtualResultViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: CustomVirtualResultViewModel
    
    //MARK: - UI Components
    
    private let rootView = CustomVirtualResultView()
    private let loadingVC = LoadingViewController()
    
    private let xButton = UIBarButtonItem(image: .icExit,
                                               style: .plain,
                                               target: nil,
                                               action: nil)
    
    private let saveView = UIImageView(image: .btnSave)
    private lazy var saveButton = UIBarButtonItem(customView: saveView)
    
    //MARK: - Life Cycle
    
    init(viewModel: CustomVirtualResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindUI()
        bindViewModel()
        setNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    private func setNavigationBar() {
        navigationItem.title = String(localized: "가상모델 AI 결과")
        navigationItem.rightBarButtonItems = [.fixedSpace(10), saveButton]
        navigationItem.leftBarButtonItems = [.fixedSpace(10), xButton]
        navigationItem.hidesBackButton = true
        
        xButton.tintColor = .white
        
        let transparentAppearance = UINavigationBar.appearance().scrollEdgeAppearance?.copy()
        transparentAppearance?.configureWithTransparentBackground()
        transparentAppearance?.titleTextAttributes = [.foregroundColor: UIColor.zw_white.cgColor,
                                                     .backgroundColor: UIColor.clear.cgColor]
        
        navigationItem.standardAppearance = transparentAppearance
        navigationItem.scrollEdgeAppearance = transparentAppearance
    }
    
    private func bindUI() {
        xButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                if let customVC = owner.navigationController?.viewControllers.first as? CustomViewController  {
                    customVC.tapAlbum()
                    }
                owner.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: disposeBag)
        
        saveView.rx.tapGesture().when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                guard let image = owner.rootView.resultImageView.image else { return }
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(self.saveCompleted),
                                               nil)
            }).disposed(by: disposeBag)
        
        rootView.productCollectionView.rx.willEndDragging
            .subscribe(with: self, onNext: { owner, data in
                let cv = owner.rootView.productCollectionView
                let offset = data.targetContentOffset
                let velocity = data.velocity
                guard velocity.x != 0 else { return }
                guard let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout else { return }
                let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
                let estimatedIndex = (cv.contentOffset.x - layout.sectionInset.left) / cellWidth
                var index: Int
                let floatFunc: (_ x: CGFloat) -> CGFloat = velocity.x > 0 ? ceil : floor
                index = Int(floatFunc(estimatedIndex))
                index = max(min(cv.numberOfItems(inSection: 0) - 1, index), 0)
                offset.pointee = CGPoint(x: CGFloat(index) * cellWidth, y: 0)
            })
            .disposed(by: disposeBag)
        
        rootView.resultImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: {owner, _ in
                let imageVC = FapImageViewController(owner.rootView.resultImageView.image)
                owner.present(imageVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        rootView.retryButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let conceptVC = owner.navigationController?.viewControllers[1]
                if let conceptVC {
                    owner.navigationController?.popToViewController(conceptVC, animated: true)
                } else {
                    owner.navigationController?.popToRootViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        rootView.scrollView.rx.contentOffset
            .asDriver(onErrorJustReturn: .zero)
            .map { $0.y / (Device.height / 3) }
            .filter { 0 <= $0 }
            .filter { $0 <= 1 }
            .drive(with: self, onNext: {owner, alpha in
                owner.navigationItem.standardAppearance?.backgroundColor = .black.withAlphaComponent(alpha)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = CustomVirtualResultViewModel.Input(
            viewDidLoadEvent: rx.viewDidLoad.asObservable(),
            productCellDidTap: rootView.productCollectionView.rx.modelSelected(PopularProductsDTO.self).asObservable(),
            applyButtonDidTap: rootView.applyButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.virtualPetImageData
            .asDriver(onErrorJustReturn: String())
            .drive(with: self, onNext: { owner, image in
                NotificationCenter.default.post(name: .refreshCustom, object: nil)
                owner.rootView.updateUI(image)
            }).disposed(by: disposeBag)
        
        output.productData
            .asDriver(onErrorJustReturn: [])
            .drive(rootView.productCollectionView.rx.items(
                cellIdentifier: CustomVirtualResultCollectionViewCell.cellIdentifier,
                cellType: CustomVirtualResultCollectionViewCell.self)
            ) { index, data , cell in
                cell.updateUI(data)
            }
            .disposed(by: disposeBag)
        
        output.pushToProductWebVC
            .asDriver(onErrorJustReturn: (String(),.init(id: Int(), image: String())))
            .drive(with: self,
                   onNext: { owner, data in
                
                let path = data.0
                let customData = data.1
                
                let webVC = DIContainer.shared.makeFapWebVC(path: path, customData: customData)
                webVC.isPopGestureEnabled = false
                owner.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension CustomVirtualResultViewController {
    @objc func saveCompleted(_ image: UIImage, 
                             didFinishSavingWithError error: Error?,
                             contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Oops\(error)")
        } else {
            showToast(
                "이미지가 저장됐어요"
            )
        }
    }
}
