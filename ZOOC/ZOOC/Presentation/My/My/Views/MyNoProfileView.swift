//
//  MyNoProfileView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/11/07.
//



import UIKit

import SnapKit
import Then

final class MyNoProfileView: UIView {
    
    // MARK: - Properties
    
    private let warningIconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    lazy var registerPetButton = UIButton()
    
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
        self.do {
            $0.setBorder(width: 1, color: .zw_brightgray)
            $0.makeCornerRound(radius: 4)
        }
        warningIconImageView.do {
            $0.image = .zwImage(.ic_warning)
        }
        titleLabel.do {
            $0.text = "아직 등록된 반려동물이 없어요"
            $0.textColor = .zw_black
            $0.textAlignment = .center
            $0.font = .zw_Subhead2
        }
        descriptionLabel.do {
            $0.text = "등록 시 자동으로 반려동물의 AI 모델이 생성 돼요"
            $0.textColor = .zw_gray
            $0.textAlignment = .center
            $0.font = .zw_Body2
        }
        registerPetButton.do {
            $0.setBorder(width: 1, color: .zw_brightgray)
            $0.setTitle("반려동물 등록", for: .normal)
            $0.setTitleColor(.zw_gray, for: .normal)
            $0.titleLabel?.font = .zw_Body2
            $0.titleLabel?.textAlignment = .center
        }
    }
    
    private func hieararchy() {
        self.addSubviews(
            warningIconImageView,
            titleLabel,
            descriptionLabel,
            registerPetButton
        )
    }
    
    private func layout() {
        warningIconImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(24)
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(warningIconImageView.snp.bottom).offset(8)
            $0.leading.equalTo(warningIconImageView)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
        }
        registerPetButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(121)
            $0.leading.trailing.bottom.equalToSuperview().inset(24)
        }
    }
}
