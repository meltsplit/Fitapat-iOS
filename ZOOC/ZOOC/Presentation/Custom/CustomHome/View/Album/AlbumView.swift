//
//  AlbumView.swift
//  ZOOC
//
//  Created by 류희재 on 2/1/24.
//

import UIKit

import SnapKit
import Then

final class AlbumView: UIView {
    
    //MARK: - UI Components
    
    let refreshController = UIRefreshControl()
    let emptyView = AlbumEmptyView()
    let albumCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomCollectionViewLayout.album.createLayout()
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func register() {
        albumCollectionView.register(
            AlbumCollectionViewSectionCell.self,
            forCellWithReuseIdentifier: AlbumCollectionViewSectionCell.cellIdentifier
        )
    }
    
    private func style() {
        [self, emptyView].forEach { $0.isHidden = true }
        
        albumCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.refreshControl = refreshController
        }
    }
    
    private func hierarchy() {
        self.addSubviews(emptyView, albumCollectionView)
    }
    private func layout() {
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        albumCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
