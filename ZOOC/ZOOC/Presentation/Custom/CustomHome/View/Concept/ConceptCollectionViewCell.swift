//
//  CommunityItemView.swift
//  ZOOC
//
//  Created by 류희재 on 12/12/23.
//

import UIKit

import SnapKit
import Then

final class ConceptCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let communityItemImageView = UIImageView()
    private let imageShadowView = InnerShadowView()
    private let nameLabel = UILabel()
    
    
    // MARK: - UI Components
    
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
        communityItemImageView.makeCornerRound(radius: 2)
        
        communityItemImageView.do {
            $0.image = .default
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        nameLabel.do {
            $0.font = .zw_Body2
            $0.textColor = .zw_white
            $0.textAlignment = .left
        }
    }
    
    private func hieararchy() {
        contentView.addSubviews(communityItemImageView, nameLabel)
        
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
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

extension ConceptCollectionViewCell {
    func dataBind(_ concept: String?, _ data: CharacterResult?) {
        nameLabel.text = data?.petName
        communityItemImageView.kfSetImage(with: data?.image)
    }
}
