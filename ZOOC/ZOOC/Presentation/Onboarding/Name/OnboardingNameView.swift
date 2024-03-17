//
//  OnboardingNameView.swift
//  ZOOC
//
//  Created by 장석우 on 3/8/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingNameView: UIView {
    
    // MARK: - Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    let nameTextField = FapTextField(placeholder: "실명을 입력해주세요",
                                      limit: 10)
    
    let nextButton = FapBottomButton(title: "다음")
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Custom Method
  
    
    private func style() {
        scrollView.showsVerticalScrollIndicator = false
        
        titleLabel.do {
            $0.font = .zw_Subhead1
            $0.text = "이름을 입력해주세요"
            $0.textAlignment = .left
            $0.textColor = .zw_black
        }
        
        descriptionLabel.do {
            $0.font = .zw_Body1
            $0.text = "닉네임 또는 가명이 아닌 실명을 입력해주세요"
            $0.textColor = .zw_gray
            $0.textAlignment = .left
        }
        
        nameTextField.do {
            $0.highlightWhenExceedLimit = false
        }
    
        nextButton.isEnabled = false
        
    }
    
    private func hierarchy() {
        
        self.addSubviews(scrollView, nextButton)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            titleLabel,
            descriptionLabel,
            nameTextField
        )
    }
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.leading.equalToSuperview().offset(28)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
        }
    }


}

