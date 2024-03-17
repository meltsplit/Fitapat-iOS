//
//  CommunityDetailViewController.swift
//  ZOOC
//
//  Created by 류희재 on 12/13/23.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

enum CustomType {
    case concept
    case character
    
    var isHidden: Bool {
        switch self {
        case .concept:
            return false
        case .character:
            return true
        }
    }
}

final class CustomDetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var detailType: CustomType
    private var detailCharacterData: DetailCustomEntity?
    
    private let viewModel: CustomDetailViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = CustomDetailView()
    private let switchButton = UIBarButtonItem(customView: CustomSwitch())
    
    init(
        detailType: CustomType,
        viewModel: CustomDetailViewModel
    ) {
        self.detailType = detailType
        rootView.setupUI(detailType)
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
        
        bindUI()
        bindViewModel()
        setNavigationBar()
    }
    
    private func bindUI() {
        switchButton.customView?.rx.tapGesture()
            .when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                guard let customView = owner.switchButton.customView as? CustomSwitch else { return }
                customView.isOn.toggle()
                owner.rootView.switchUI(owner.detailType)
            }).disposed(by: disposeBag)
        
        rootView.saveImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                guard let image = owner.rootView.customImageView.image else { return }
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(self.saveCompleted),
                                               nil)
                
            }).disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        let input = CustomDetailViewModel.Input(
            viewWillAppearEvent: rx.viewWillAppear.map { self.detailType }.asObservable(),
            conceptApplyButtonDidTap:  rootView.conceptDetailAIButton.rx.tap.asObservable(),
            albumBuyButtonDidTap: rootView.albumDetailAIButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.detailCharacterData
            .asDriver(onErrorJustReturn: nil)
            .filter { $0 != nil }
            .drive(with: self, onNext: { owner, data in
                owner.detailCharacterData = data
                owner.navigationItem.title = "\(data!.concept.name) 컨셉"
                owner.rootView.updateUI(data!)
            }).disposed(by: disposeBag)
        
        output.keywordData
            .asDriver(onErrorJustReturn: [])
            .drive(rootView.conceptItemCollectionView.rx.items(
                cellIdentifier: CustomDetailKeywordPromptCell.cellIdentifier,
                cellType: CustomDetailKeywordPromptCell.self
            )) { _, data, cell in
                cell.dataBind(data)
            }.disposed(by: disposeBag)
        
        output.applyButtonOutput
            .asDriver(onErrorJustReturn: .normal)
            .drive(with: self, onNext: { owner, state in
                switch state {
                case .first:
                    let firstTicketVC = FirstTicketAlertViewController(delegate: owner)
                    owner.present(firstTicketVC, animated: false)
                case .normal:
                    owner.pushCustomMainVC()
                case .notEnough:
                    let exhauseTicketVC = ExhuastedTicketAlertViewController(delegate: owner)
                    owner.present(exhauseTicketVC, animated: false)
                }
                
            })
            .disposed(by: disposeBag)
        
        output.pushToSelfCustomWebVC
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: pushToSelfCustomWebVC)
            .disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        let backItemAppearance = UINavigationBar.appearance().scrollEdgeAppearance?.backButtonAppearance.copy()
        backItemAppearance?.normal.backgroundImage = .icBack.withTintColor(.white)
        
        let scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance?.copy()
        scrollEdgeAppearance?.configureWithTransparentBackground()
        
        scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor.white.cgColor,
                                                     .backgroundColor: UIColor.clear.cgColor]
        
        navigationItem.rightBarButtonItem = switchButton
        
        if let backItemAppearance { scrollEdgeAppearance?.backButtonAppearance = backItemAppearance }
        
        navigationItem.scrollEdgeAppearance = scrollEdgeAppearance
    }
    
    //MARK: - Action Method
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Oops\(error)")
        } else {
            showToast("이미지가 저장됐어요")
        }
    }
}

extension CustomDetailViewController: FirstTicketAlertViewDelegate {
    func firstTicketConfirmButtonDidTap() {
        pushCustomMainVC()
    }
}

extension CustomDetailViewController: ExhuastedTicketAlertViewDelegate {
    func exhuastedTicketConfirmButtonDidTap() {
        pushToSelfCustomWebVC(nil)
    }
}


extension CustomDetailViewController {
    private func pushCustomMainVC() {
        var keywordDictionary: [CustomKeywordType : PromptDTO?]? = [:]
        for (key, value) in detailCharacterData!.keywordData {
            keywordDictionary?[key] = value
        }
        
        let customMainVC = DIContainer.shared.makeMainCustomVC(
            detailCharacterData!.concept,
            keywordDictionary
        )
        self.navigationController?.pushViewController(customMainVC, animated: true)
    }
    
    private func pushToSelfCustomWebVC(_ data: MakeCharacterResult?) {
        let webVC = DIContainer.shared.makeFapWebVC(path: "/custom", customData: data)
        navigationController?.pushViewController(webVC, animated: true)
    }
}


