//
//  ChooseConceptCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 12/13/23.
//

import UIKit

import SnapKit
import Then

final class ChooseConceptCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let backgroundImageView = UIImageView()
    private let imageShadowView = InnerShadowView()
    private let newLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = PetNameLabel()
    
    private let commingSoonContentView = UIView()
    private let comingSoonLogoImageView = UIImageView()
    private let commingSoonTitleLabel = UILabel()
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hieararchy()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        newLabel.setBorder(width: 1, color: .zw_white)
        newLabel.makeCornerRound(ratio: 2)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func style() {
        
        backgroundImageView.makeCornerRound(radius: 2)
        
        backgroundImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = .default
        }
        
        newLabel.do {
            $0.font = .price_small
            $0.text = "new"
            $0.textColor = .zw_white
            $0.backgroundColor = .zw_white.withAlphaComponent(0.1)
            $0.textAlignment = .center
        }
        
        
        titleLabel.do {
            $0.font = .zw_Subhead3
            $0.textColor = .zw_white
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
        
        descriptionLabel.do {
            $0.font = .zw_Body3
            $0.textAlignment = .left
            $0.lineBreakMode = .byCharWrapping
            $0.textColor = .zw_white
            $0.numberOfLines = 0
        }
        
        commingSoonContentView.do {
            $0.backgroundColor = .init(r: 200, g: 200, b: 200)
        }

        comingSoonLogoImageView.do {
            $0.image = .icLock
        }
        
        commingSoonTitleLabel.do {
            $0.text = "Comming Soon!"
            $0.textColor = .zw_white
            $0.font = .pretendard(font: .regular, size: 14)
            $0.textAlignment = .center
        }
    }
    
    private func hieararchy() {
        contentView.addSubviews(
            backgroundImageView,
            newLabel,
            titleLabel,
            descriptionLabel,
            commingSoonContentView
        )
        
        commingSoonContentView.addSubviews(
            comingSoonLogoImageView,
            commingSoonTitleLabel
        )
        
        
        backgroundImageView.addSubview(imageShadowView)
    }
    
    private func layout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        newLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(14)
            $0.height.equalTo(20)
            $0.width.equalTo(43)
        }
        
        imageShadowView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-4)
            $0.horizontalEdges.equalTo(descriptionLabel)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
        
        commingSoonContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        comingSoonLogoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(22)
        }
        
        commingSoonTitleLabel.snp.makeConstraints {
            $0.top.equalTo(comingSoonLogoImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension ChooseConceptCollectionViewCell {
    
    func dataBind(_ data: CustomConceptResult) {
        commingSoonContentView.isHidden = data != .commingSoon()
        newLabel.isHidden = true
        imageShadowView.isHidden = false
        titleLabel.text = data.name  + " " + String(localized: "컨셉")
        descriptionLabel.text = data.description
        backgroundImageView.kfSetImage(with: data.image)
    }
}

