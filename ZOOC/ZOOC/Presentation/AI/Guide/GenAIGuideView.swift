//
//  GenAIView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/15.
//

import UIKit

import SnapKit
import Then

final class GenAIGuideView: UIView {
    
    //MARK: - UI Components
    
    private let descriptionLabel = UILabel()
    private let subDescriptionLabel = UILabel()
    private let separator = UIView()
    
    private let featuredImageView = UIImageView()
    private let featuredDescribeLabel = UILabel()
    private let featuredSubDescribeLabel = UILabel()
    
    let deprecatedView = UIStackView()
    private let deprecatedTitleLabel = UILabel()
    
    public lazy var selectImageButton = UIButton()
    
    //MARK: - Life Cycles
    
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
        descriptionLabel.do {
            $0.text = "반려동물의 사진을 선택해주세요"
            $0.textColor = .zw_black
            $0.font = .zw_Subhead1
            $0.textAlignment = .center
        }
        
        subDescriptionLabel.do {
            $0.text = "최적의 학습을 위해 아래 기준을 추천드려요"
            $0.textColor = .zw_gray
            $0.font = .zw_Body1
            $0.textAlignment = .center
        }
        
        separator.do {
            $0.backgroundColor = .zw_brightgray
        }
        
        featuredImageView.do {
            $0.image = .zwImage(.mockfeaturedImage)
        }
        
        featuredDescribeLabel.do {
            $0.text = "비슷한 자세의 정면 사진들이 가장 좋아요"
            $0.font = .zw_Body1
            $0.textAlignment = .center
            $0.textColor = .zw_black
            $0.asColor(
                targetString: "정면 사진들이",
                color: .zw_point
            )
        }
        
        featuredSubDescribeLabel.do {
            $0.text = "한 마리의 사진으로만 8 - 15장을 업로드 해주세요"
            $0.font = .zw_Body2
            $0.textAlignment = .center
            $0.textColor = .zw_gray
        }
        
        deprecatedView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        deprecatedTitleLabel.do {
            $0.text = "아래 경우의 사진들은 AI 인식이 어려워요"
            $0.font = .zw_Body1
            $0.textAlignment = .center
            $0.textColor = .zw_black
        }
        
        selectImageButton.do {
            $0.backgroundColor = .zw_black
            $0.setTitle("8 - 15장의 사진 업로드", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Subhead1
            $0.titleLabel?.textAlignment = .center
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            descriptionLabel,
            subDescriptionLabel,
            separator,
            featuredDescribeLabel,
            featuredImageView,
            featuredSubDescribeLabel,
            deprecatedTitleLabel,
            deprecatedView,
            selectImageButton
        )
    }
    
    private func layout() {
            
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(54)
            $0.centerX.equalToSuperview()
        }
        
        subDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(subDescriptionLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(1)
        }
        
        //Featured View
        
        featuredDescribeLabel.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        featuredImageView.snp.makeConstraints {
            $0.top.equalTo(featuredDescribeLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(42)
            $0.height.equalTo(90)
        }
        
        featuredSubDescribeLabel.snp.makeConstraints {
            $0.top.equalTo(featuredImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        deprecatedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(featuredSubDescribeLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        deprecatedView.snp.makeConstraints {
            $0.top.equalTo(deprecatedTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(43)
            $0.bottom.equalToSuperview().inset(110)
        }
        
        selectImageButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
}


