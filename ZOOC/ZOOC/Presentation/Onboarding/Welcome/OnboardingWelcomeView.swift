//
//  OnboardingWelcomeView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

final class OnboardingWelcomeView: UIView {
    
    //MARK: - UI Components
    
    public let welcomeLabel = UILabel()
    public let desriptionLabel = UILabel()
    public lazy var goHomeButton = UIButton()
    
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
        self.backgroundColor = .zw_background
        
        welcomeLabel.do {
            $0.text = String(localized: "핏어팻 회원가입을\n진심으로 환영해요!")
            $0.textColor = .zw_black
            $0.textAlignment = .left
            $0.font = .gmarket(font: .light, size: 30)
            $0.numberOfLines = 3
            $0.setLineSpacing(spacing: 10)
            $0.setAttributeLabel(
                targetString: [String(localized: "핏어팻")],
                color: .zw_black,
                font: .gmarket(font: .medium, size: 30),
                spacing: 10
            )
        }
        
        desriptionLabel.do {
            $0.text = String(localized: "사랑하는 반려동물과 회원님만을 위한\n특별한 설렘을 선물할게요")
            $0.textColor = .zw_black
            $0.textAlignment = .left
            $0.font = .pretendard(font: .light, size: 16)
            $0.numberOfLines = 3
            $0.setLineSpacing(spacing: 4)
        }
        
        goHomeButton.do {
            $0.backgroundColor = .zw_black
            $0.setTitle(String(localized: "홈에서 둘러보기"), for: .normal)
            $0.titleLabel?.font = .zw_Subhead1
            $0.setTitleColor(.zw_white, for: .normal)
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            welcomeLabel,
            desriptionLabel,
            goHomeButton
        )
    }
    
    private func layout() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().offset(28)
        }
        
        desriptionLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        goHomeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
}
