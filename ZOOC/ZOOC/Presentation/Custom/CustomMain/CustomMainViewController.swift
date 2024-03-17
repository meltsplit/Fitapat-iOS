//
//  CustomSelectKeywordViewController.swift
//  ZOOC
//
//  Created by 장석우 on 12/16/23.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture

final class CustomMainViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: CustomMainViewModel
    private let disposeBag = DisposeBag()
    private let promptLabelDidTap = PublishRelay<CustomKeywordType>()
    
    
    //MARK: - UI Components
    
    private let rootView = CustomMainView()
    
    private let contentVC = RecommendKeywordPromptsBottomSheet()
    private lazy var bottomSheetVC = BottomSheetViewController(isTouchPassable: false,
                                                               contentViewController: contentVC)
    private let loadingVC = LoadingViewController()
    
    private let xButton = UIBarButtonItem(image: .icExit,
                                               style: .plain,
                                               target: nil,
                                               action: nil)
    
    //MARK: - Life Cycle
    
    init(viewModel: CustomMainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        bindUI()
        bindViewModel()
        setNavigationBar()
        loadingVC.delegate = self
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Custom Method
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItems = [.fixedSpace(10), xButton]
        xButton.tintColor = .white
        
        let backItemAppearance = UINavigationBar.appearance().scrollEdgeAppearance?.backButtonAppearance.copy()
        backItemAppearance?.normal.backgroundImage = .icBack.withTintColor(.white)
        
        let scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance?.copy()
        scrollEdgeAppearance?.configureWithTransparentBackground()
        scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor.white.cgColor,
                                                     .backgroundColor: UIColor.clear.cgColor]
        if let backItemAppearance { scrollEdgeAppearance?.backButtonAppearance = backItemAppearance }
        
        navigationItem.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    private func bindUI() {
        
        xButton.rx.tap
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, _ in
                let zoocAlertVC = FapAlertViewController(.leaveCustomPage)
                zoocAlertVC.delegate = self
                owner.present(zoocAlertVC, animated: false)
            }).disposed(by: disposeBag)
        
        
        Observable.merge(rootView.bgPromptLabel.rx.tapGesture().when(.recognized).map{_ in},
                         rootView.bgButton.rx.tap.asObservable())
            .do(onNext: { Haptic.selection.run() })
            .map { CustomKeywordType.background}
            .bind(to: promptLabelDidTap)
            .disposed(by: disposeBag)
        
        Observable.merge(rootView.outfitPromptLabel.rx.tapGesture().when(.recognized).map{_ in},
                         rootView.outfitButton.rx.tap.asObservable())
            .do(onNext: { Haptic.selection.run() })
            .map { CustomKeywordType.outfit}
            .bind(to: promptLabelDidTap)
            .disposed(by: disposeBag)
        
        Observable.merge(rootView.accPromptLabel.rx.tapGesture().when(.recognized).map{_ in},
                         rootView.accButton.rx.tap.asObservable()) 
            .do(onNext: { Haptic.selection.run() })
            .map { CustomKeywordType.accesorry}
            .bind(to: promptLabelDidTap)
            .disposed(by: disposeBag)
        
        contentVC.collectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                Haptic.impact(.light).run() 
                owner.bottomSheetVC.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        contentVC.resetButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.bottomSheetVC.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        
        let input = CustomMainViewModel.Input(
            viewDidLoadEvent: rx.viewDidLoad.asObservable(),
            keywordPromptCellDidTapEvent: promptLabelDidTap.asObservable(),
            recommendPromptCellDidTapEvent: contentVC.collectionView.rx.modelSelected((CustomKeywordType, RecommendKeywordResult).self).asObservable(),
            resetKeywordButtonDidTapEvent: contentVC.resetButton.rx.tap.asObservable(),
            doneButtonDidTapEvent: rootView.doneButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.backgroundImageData
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: rootView.updateBackgroundImage)
            .disposed(by: disposeBag)
        
        output.recommendPromptsData
            .asDriver(onErrorJustReturn: [])
            .drive(contentVC.collectionView.rx.items(
                cellIdentifier: RecommendPromptCollectionViewCell.cellIdentifier,
                cellType: RecommendPromptCollectionViewCell.self)
            ) { index, data, cell in
                cell.updateUI(data)
            }
            .disposed(by: disposeBag)
        
        output.currentKeywordsPromptData
            .asDriver(onErrorJustReturn: (.accesorry, nil))
            .drive(onNext: rootView.updatePromptLabelUI)
            .disposed(by: disposeBag)
    
        output.showPromptEditView
            .asDriver(onErrorJustReturn: .accesorry)
            .drive(with: self, onNext: { owner, data in
                guard !owner.bottomSheetVC.isBeingPresented else { return }
                owner.contentVC.updateUI(data)
                owner.present(owner.bottomSheetVC, animated: true)
            })
            .disposed(by: disposeBag)
            
        output.showToast
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: presentToast)
            .disposed(by: disposeBag)
        
        output.showLoading
            .asDriver(onErrorJustReturn: Bool())
            .drive(with: self, onNext: { owner, isLoading in
                if isLoading {
                    owner.present(owner.loadingVC, animated: false)
                } else {
                    owner.loadingVC.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        output.change을를
            .asDriver(onErrorJustReturn: String())
            .drive(with: self, onNext: { owner, 을or를 in
                owner.rootView.update을를(을or를)
            })
            .disposed(by: disposeBag)
        
        output.notEnoughTicket
            .asDriver(onErrorJustReturn: ())
            .drive(with: self, onNext: { owner, _ in
                owner.present(ExhuastedTicketAlertViewController(delegate: owner), animated: false)  
            })
            .disposed(by: disposeBag)
        
        output.pushCustomVirtualResultVC
            .asDriver(onErrorJustReturn: .init(id: Int(), image: String()))
            .drive(with: self, onNext: { owner, data in
                let resultVC = DIContainer.shared.makeCustomVirtualResultVC(data)
                resultVC.isPopGestureEnabled = false
                owner.navigationController?.pushViewController(resultVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension CustomMainViewController: FapAlertViewControllerDelegate {
    func leftButtonDidTap(_ alertType: FapAlertType) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func rightButtonDidTap(_ alertType: FapAlertType) {
        return
    }
}


extension CustomMainViewController: LoadingViewControllerDelegate {
    func xButtonDidTap() {
        
        navigationController?.popToRootViewController(animated: true)
    }
}

extension CustomMainViewController: ExhuastedTicketAlertViewDelegate {
    func exhuastedTicketConfirmButtonDidTap() {
        let webVC = DIContainer.shared.makeFapWebVC(path: "/custom")
        navigationController?.pushViewController(webVC, animated: true)
    }
}

