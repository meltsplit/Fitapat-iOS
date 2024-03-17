//
//  ConceptDetailView.swift
//  ZOOC
//
//  Created by 류희재 on 12/13/23.
//

import UIKit

import SnapKit
import Then

final class ChooseConceptView: UIView {
    
    // MARK: - Properties
    
    lazy var chooseConceptCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func register() {
        chooseConceptCollectionView.register(
            ChooseConceptCollectionViewCell.self,
            forCellWithReuseIdentifier: ChooseConceptCollectionViewCell.cellIdentifier
        )
        
        
        chooseConceptCollectionView.register(
            ChooseConceptCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ChooseConceptCollectionHeaderView.reuseCellIdentifier)

        
    }
    
    private func style() {
        
        
        chooseConceptCollectionView.do {
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(
                width: (Device.width - 28 * 2 - 7) / 2,
                height: (Device.width - 56) * 118 / 156
            )
            
            layout.headerReferenceSize = CGSize(
                width: Device.width,
                height: 140
            )
      
            
            layout.sectionInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 8,
                right: 0
            )
            
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .vertical
            
            
            $0.collectionViewLayout = layout
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceVertical = true
            

            $0.backgroundColor = .clear
        }
    }
    
    private func hieararchy() {
        
        addSubviews(chooseConceptCollectionView)
        
    }
    
    private func layout() {

        chooseConceptCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview()
        }
    }
}
