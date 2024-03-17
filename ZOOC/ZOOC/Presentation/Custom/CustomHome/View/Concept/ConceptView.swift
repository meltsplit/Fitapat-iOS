//
//  CommunityView.swift
//  ZOOC
//
//  Created by 류희재 on 12/12/23.
//

import UIKit

import SnapKit
import Then

final class ConceptView: UICollectionView  {
    
    //MARK: - UI Components
    
    let refreshController = UIRefreshControl()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: .init())
        
        register()
        
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func register() {
        self.register(
            ConceptCollectionViewSectionCell.self,
            forCellWithReuseIdentifier: ConceptCollectionViewSectionCell.cellIdentifier
        )
    }
    
    private func style() {
        self.do {
            let layout = CustomCollectionViewLayout.concept.createLayout()
            $0.collectionViewLayout = layout
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.refreshControl = refreshController
        }
    }
}
