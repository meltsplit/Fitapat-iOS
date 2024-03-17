//
//  ChooseConceptHeaderView.swift
//  ZOOC
//
//  Created by 장석우 on 12/16/23.
//

import UIKit

import SnapKit
import Then

final class ChooseConceptCollectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let descriptionLabel = PetNameLabel()
    
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
        titleLabel.do {
            $0.text = "커스텀 하고 싶은 컨셉을 선택해주세요"
            $0.font = .zw_Subhead1
            $0.textColor = .zw_black
            $0.textAlignment = .left
        }
        
        descriptionLabel.do {
            $0.text = "{pet}의 다채로운 모습을 직접 만들어요"
            $0.font = .zw_Body1
            $0.textColor = .zw_gray
            $0.textAlignment = .center
        }
    }
    
    private func hieararchy() {
        self.addSubviews(
            titleLabel,
            descriptionLabel
        )
    }
    
    private func layout() {
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
    }
}
