//
//  OnboardingAgreementViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit
import SafariServices

import RxSwift
import RxCocoa
import RxDataSources

final class OnboardingAgreementViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let viewModel: OnboardingAgreementViewModel
    
    private var allChecked: Bool = false
    private let allAgreementCheckButtonDidTapEventSubject = PublishSubject<Void>()
    private let agreementSeeLabelDidTapEventSubject = PublishSubject<Int>()
    
    var sectionSubject = BehaviorRelay(value: [SectionData<OnboardingAgreementModel>]())
    private var dataSource:  RxCollectionViewSectionedReloadDataSource<SectionData<OnboardingAgreementModel>>?
    
    //MARK: - UI Components
    
    private lazy var rootView = OnboardingAgreementView()
    
    //MARK: - Life Cycle
    
    init(viewModel: OnboardingAgreementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bindUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configureCollectionViewDataSource()
        configureCollectionView()
    }
    
    //MARK: - Custom Method
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionData<OnboardingAgreementModel>>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OnboardingAgreementCollectionViewCell.cellIdentifier,
                    for: indexPath
                ) as! OnboardingAgreementCollectionViewCell
                cell.dataBind(tag: indexPath.row, data: item)
                cell.delegate = self
                return cell
            },configureSupplementaryView: { [weak self] (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
                guard let self else { return UICollectionReusableView() }
                let kind = UICollectionView.elementKindSectionHeader
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OnboardingAgreementCollectionHeaderView.reuseCellIdentifier, for: indexPath) as! OnboardingAgreementCollectionHeaderView
                header.updateUI(allChecked)
                header.delegate = self
                return header
            })
    }
    
    func configureCollectionView() {
        guard let dataSource else { return }
        sectionSubject
            .bind(to: rootView.agreementCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        agreementSeeLabelDidTapEventSubject
            .subscribe(with: self, onNext: { owner, index in
                var url = ExternalURL.fapDefaultURL
                switch index {
                case 0: url = ExternalURL.termsOfUse
                case 1: url = ExternalURL.privacyPolicy
                case 2: break
                case 3: url = ExternalURL.consentMarketing
                default: break
                }
                owner.presentSafariViewController(url)
            }).disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = OnboardingAgreementViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            allAgreementCheckButtonDidTapEvent: allAgreementCheckButtonDidTapEventSubject.asObservable(),
            agreementCheckButtonDidTapEvent: rootView.agreementCollectionView.rx.itemSelected.asObservable().map { $0.item },
            nextButtonDidTapEvent: rootView.signUpButton.rx.tap.asObservable().throttle(.seconds(2),latest: false, scheduler: MainScheduler.instance)
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.nextButtonTitle
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, title in
                owner.rootView.signUpButton.setTitle(title, for: .normal)
                dump(title)
            })
            .disposed(by: disposeBag)
        
        output.agreementList.subscribe(with: self, onNext: { owner, agreementList in
            var updateSection: [SectionData<OnboardingAgreementModel>] = []
            updateSection.append(SectionData<OnboardingAgreementModel>(items: agreementList))
            owner.sectionSubject.accept(updateSection)
        }).disposed(by: disposeBag)
        
        output.ableToSignUp
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, canSignUp in
                let updateColor: UIColor = canSignUp ? .zw_black : .zw_lightgray
                owner.rootView.signUpButton.backgroundColor = updateColor
            }).disposed(by: disposeBag)
        
        output.allChecked
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, allChecked in
                owner.allChecked = allChecked
            }).disposed(by: disposeBag)
        
        output.showToast
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, text in
                owner.showToast(text)
            }).disposed(by: disposeBag)
        
        output.nextDestination
            .asDriver(onErrorJustReturn: (.unknown, SignUpNotNeedState(), .unknown() ))
            .drive(with: self, onNext: { owner, data in
                owner.navigationOnboarding(data)
            }).disposed(by: disposeBag)
        
        output.nextButtonTitle
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, title in owner.rootView.signUpButton.setTitle(title, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}



//MARK: - AllChekedButtonTappedDelegate

extension OnboardingAgreementViewController: CheckedButtonTappedDelegate {
    func seeLabelDidTapped(index: Int) {
        agreementSeeLabelDidTapEventSubject.onNext(index)
    }
}

extension OnboardingAgreementViewController: AllChekedButtonTappedDelegate {
    func allCellButtonTapped() {
        allChecked.toggle()
        allAgreementCheckButtonDidTapEventSubject.onNext(())
    }
}
