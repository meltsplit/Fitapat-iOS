//
//  ConceptViewController.swift
//  ZOOC
//
//  Created by 류희재 on 12/13/23.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class ChooseConceptViewController: BaseViewController {
     
    //MARK: - Dependency
    
    private let viewModel: ChooseConceptViewModel
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let rootView = ChooseConceptView()
    
    private let ticketView = TicketView()
    private lazy var ticketButton = UIBarButtonItem(customView: ticketView)

    //MARK: - Life Cycle
    
    init(viewModel: ChooseConceptViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        title = "컨셉 선택"
        navigationItem.rightBarButtonItems = [.fixedSpace(10), ticketButton]
        bindUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    private func bindUI() {
        ticketView.rx.tapGesture()
            .when(.recognized)
            .map { _ in "내가 커스텀 AI 캐릭터를 만들 수 있는 잔여 횟수예요\n만든 캐릭터로 커스텀 제품을 구매하면 5장을 더 드려요" }
            .bind(onNext: presentToastAtTop)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let input = ChooseConceptViewModel.Input(
            viewDidLoadEvent: rx.viewDidLoad.asObservable(), 
            viewWillAppear: rx.viewWillAppear.asObservable(),
            conceptCellDidTap: rootView.chooseConceptCollectionView.rx.modelSelected(CustomConceptResult.self).asObservable()
        )
           
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionData<CustomConceptResult>>(
            configureCell: { (_, collectionView, indexPath, data) in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ChooseConceptCollectionViewCell.cellIdentifier,
                    for: indexPath) as! ChooseConceptCollectionViewCell
                cell.dataBind(data)
                return cell },
            configureSupplementaryView: { (_, collectionView, kind, indexPath) in
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ChooseConceptCollectionHeaderView.reuseCellIdentifier,
                    for: indexPath)
                return headerView}
        )
        
        output.conceptData
            .bind(to: rootView.chooseConceptCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.pushToMakePromptVC
            .asDriver(onErrorJustReturn: .init(id: Int(), name: String(), description: "", image: ""))
            .drive(with: self, onNext: { owner, data in
                let vc = DIContainer.shared.makeMainCustomVC(data, nil)
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.ticketData
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: ticketView.updateUI)
            .disposed(by: disposeBag)
    }
}
