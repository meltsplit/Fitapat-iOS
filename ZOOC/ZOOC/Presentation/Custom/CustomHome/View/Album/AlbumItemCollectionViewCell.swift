//
//  AlbumItemCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 1/30/24.
//

import UIKit

import SnapKit
import Then

final class AlbumItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let paidupTag = UIButton()
    private let communityItemImageView = UIImageView()
    private let imageShadowView = InnerShadowView()
    private let conceptNameLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func style() {
        paidupTag.do {
            $0.setTitle("구매완료", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Body3
            $0.titleLabel?.textAlignment = .center
            $0.setBorder(width: 1, color: .zw_white)
            $0.makeCornerRound(radius: 14)
        }
        
        communityItemImageView.do {
            $0.makeCornerRound(radius: 2)
            $0.image = .default
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        conceptNameLabel.do {
            $0.font = .zw_Body2
            $0.textColor = .zw_white
            $0.textAlignment = .left
        }
    }
    
    private func hieararchy() {
        contentView.addSubviews(
            communityItemImageView,
            paidupTag,
            conceptNameLabel
        )
        
        communityItemImageView.addSubview(imageShadowView)
    }
    
    private func layout() {
        communityItemImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageShadowView.snp.makeConstraints {
            $0.top.equalTo(communityItemImageView.snp.centerY)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        paidupTag.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
        
        conceptNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

extension AlbumItemCollectionViewCell {
    func updateUI(_ data: CustomCharacterResult) {
        communityItemImageView.kfSetImage(with: data.image)
        conceptNameLabel.text = "\(data.conceptName) 컨셉"
        paidupTag.isHidden = !data.hasPurchased
    }
}
