//
//  GenAIDeprecatedView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/11/10.
//



import UIKit

import SnapKit
import Then

final class GenAIDeprecatedView: UIView {

    // MARK: - UI Components
    
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
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
        
        descriptionLabel.do {
            $0.textColor = .zw_gray
            $0.textAlignment = .center
            $0.font = .zw_Body2
        }
    }
    
    private func hieararchy() {
        self.addSubviews(imageView, descriptionLabel)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.size.equalTo(90)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}

extension GenAIDeprecatedView {
    func dataBind(_ data: GenAIGuideModel) {
        imageView.image = data.image
        descriptionLabel.text = data.text
    }
}
