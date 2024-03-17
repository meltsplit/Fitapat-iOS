//
//  CommunityCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 12/12/23.
//

import UIKit

import SnapKit
import Then

protocol CustomItemCellDelegate: AnyObject {
    func conceptItemCellDidSelect(_ data: CharacterResult)
}

final class ConceptCollectionViewSectionCell: UICollectionViewCell {
    
    var conceptName: String?
    var sampleCharacterData: [CharacterResult] = [] {
        didSet {
            sampleCharacterCollectionView.reloadData()
        }
    }
    
    weak var delegate: CustomItemCellDelegate?
    
    private let descriptionImageView = UIImageView()
    private let imageShadowView = InnerShadowView()
    
    private let titleLabel = UILabel()
    private let subTitleLabel = PetNameLabel()
    private let sampleCharacterCollectionView = UICollectionView.init(
        frame: .zero,
        collectionViewLayout: CustomCollectionViewLayout.conceptItem.createLayout()
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        setDelegate()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        sampleCharacterCollectionView.delegate = self
        sampleCharacterCollectionView.dataSource = self
    }
    
    private func register() {
        sampleCharacterCollectionView.register(
            ConceptCollectionViewCell.self,
            forCellWithReuseIdentifier: ConceptCollectionViewCell.cellIdentifier
        )
    }
    
    private func style() {
        descriptionImageView.do {
            $0.makeCornerRound(radius: 2)
            $0.contentMode = .scaleAspectFill
        }
        
        titleLabel.do {
            $0.font = .zw_Subhead3
            $0.textAlignment = .center
            $0.textColor = .zw_white
        }
        
        subTitleLabel.do {
            $0.font = .zw_Body2
            $0.textAlignment = .center
            $0.textColor = .zw_white
        }
        
        sampleCharacterCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(
            descriptionImageView,
            sampleCharacterCollectionView
        )
        
        descriptionImageView.addSubviews(
            imageShadowView,
            titleLabel,
            subTitleLabel
        )
    }
    
    private func layout() {
        descriptionImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(100)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(43)
            $0.leading.equalToSuperview().offset(16)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel)
        }
        sampleCharacterCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        imageShadowView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(74)
        }
    }
}

extension ConceptCollectionViewSectionCell {
    func updateUI(_ data: ConceptItemEntity) {
        let conceptData = data.conceptData
        descriptionImageView.kfSetImage(with: conceptData.image)
        titleLabel.text = conceptData.name + " 컨셉"
        subTitleLabel.text = conceptData.description
        sampleCharacterData = data.sampleCharacterData
        conceptName = data.conceptData.name
    }
}

extension ConceptCollectionViewSectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.conceptItemCellDidSelect(sampleCharacterData[indexPath.item])
    }
}

extension ConceptCollectionViewSectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleCharacterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ConceptCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as! ConceptCollectionViewCell
        cell.dataBind(conceptName,
            sampleCharacterData[indexPath.item])
        return cell
    }
}



