//
//  CustomResultCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 12/18/23.
//

import UIKit

import SnapKit
import Then

final class CustomVirtualResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let vStackView = UIStackView()
    
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
        
//        contentView.backgroundColor = .systemGray.withAlphaComponent(0.5)
//        vStackView.backgroundColor = .systemPink.withAlphaComponent(0.5)
//        productImageView.backgroundColor = .yellow.withAlphaComponent(0.5)
        
        vStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 9
            
        }
        
        productImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.font = .zw_Subhead3
            $0.textColor = .zw_white
            $0.textAlignment = .center
        }
    
        priceLabel.do {
            $0.font = .price_middle
            $0.textColor = .zw_white
            $0.textAlignment = .center
        }
    }
    
    private func hieararchy() {
        contentView.addSubview(vStackView)
        vStackView.addArrangedSubViews(
            productImageView,
            titleLabel,
            priceLabel
        )
    }
    
    private func layout() {
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        productImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        productImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        productImageView.snp.makeConstraints {
            $0.size.equalTo(280 * Device.width / 375)
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
}

extension CustomVirtualResultCollectionViewCell {
    func updateUI(_ data: PopularProductsDTO) {
        productImageView.kfSetImage(with: data.image, placeholder: .defaultImageBlack)
        titleLabel.text = data.name
        priceLabel.text = data.price.priceText
    }
}


