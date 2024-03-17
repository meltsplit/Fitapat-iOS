//
//  AlbumCollectionViewSectionCell.swift
//  ZOOC
//
//  Created by 류희재 on 1/30/24.
//

import UIKit

import SnapKit
import Then

protocol AlbumItemCellDelegate: AnyObject {
    func albumItemCellDidSelect(_ data: CustomCharacterResult)
}

final class AlbumCollectionViewSectionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private var characterData: [CustomCharacterResult] = [] {
        didSet {
            albumItemCollectionView.reloadData()
        }
    }
    
    weak var delegate: AlbumItemCellDelegate?
    
    // MARK: - UI Components
    
    private let dateLabel = UILabel()
    private let albumItemCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomCollectionViewLayout.albumItem.createLayout()
    )
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegate()
        register()
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func setDelegate() {
        albumItemCollectionView.delegate = self
        albumItemCollectionView.dataSource = self
    }
    
    private func register() {
        albumItemCollectionView.register(
            AlbumItemCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumItemCollectionViewCell.cellIdentifier
        )
    }
    
    private func style() {
        dateLabel.do {
            $0.font = .price_middle
            $0.textAlignment = .left
            $0.textColor = .zw_black
        }
        
        albumItemCollectionView.do {
            $0.backgroundColor = .clear
        }
    }
    
    private func hieararchy() {
        contentView.addSubviews(
            dateLabel,
            albumItemCollectionView
        )
    }
    
    private func layout() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        albumItemCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension AlbumCollectionViewSectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.albumItemCellDidSelect(characterData[indexPath.item])
    }
}

extension AlbumCollectionViewSectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumItemCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as! AlbumItemCollectionViewCell
        cell.updateUI(characterData[indexPath.item])
        return cell
    }
}

extension AlbumCollectionViewSectionCell {
    func updateUI(_ data: [String : [CustomCharacterResult]]) {
        dateLabel.text = data.keys.first
        characterData = data.values.first!
    }
}
