//
//  OnboardingLoginView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import AuthenticationServices
import SnapKit
import Then

final class OnboardingLoginView: UIView {
    
    //MARK: - UI Components
    
    private let loginTitleLabel = UILabel()
    private let loginDescribeLabel = UILabel()
    private let lineView = UIView()
    
    public let kakaoLoginButton = UIButton()
    public let appleLoginButton = UIButton()
    
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
        loginTitleLabel.do {
            $0.text = String(localized: "사랑하는 반려동물과\n매순간\n함께하는 최고의 방법")
            $0.textColor = .zw_black
            $0.textAlignment = .left
            $0.font = .gmarket(font: .light, size: 30)
            $0.numberOfLines = 3
            $0.setLineSpacing(spacing: 10)
            $0.setAttributeLabel(
                targetString: [String(localized: "함께")],
                color: .zw_black,
                font: .gmarket(font: .medium, size: 30),
                spacing: 10
            )
        }
        lineView.backgroundColor = .zw_darkgray
        loginDescribeLabel.do {
            $0.text = "1초만에 가입하고 반려동물 사진 6장만\n등록하면 간편하게 주문 완료"
            $0.textColor = .zw_gray
            $0.textAlignment = .left
            $0.numberOfLines = 2
            $0.font = .pretendard(font: .light, size: 16)
            $0.setLineSpacing(spacing: 4)
        }
        
        kakaoLoginButton.do {
            $0.backgroundColor = .init(r: 255, g: 231, b: 0)
            $0.setTitle(String(localized: "카카오톡으로 로그인"), for: .normal)
            $0.setTitleColor(.init(r: 55, g: 28, b: 29), for: .normal)
            $0.titleLabel?.font = .zw_Subhead1
            $0.setImage(.zwImage(.ic_kakao), for: .normal)
            $0.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 8)
        }
        
        appleLoginButton.do {
            $0.backgroundColor = .init(r: 38, g: 38, b: 38)
            $0.setTitle(String(localized: "Apple로 로그인"), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.tintColor = .white
            $0.titleLabel?.font = .zw_Subhead1
            $0.setImage(.zwImage(.ic_apple), for: .normal)
            $0.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 8)
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 9, right: 0)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            loginTitleLabel,
            lineView,
            loginDescribeLabel,
            appleLoginButton,
            kakaoLoginButton
        )
    }
    
    private func layout() {
        loginTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().offset(28)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(95)
            $0.leading.equalToSuperview().offset(127)
            $0.trailing.equalToSuperview().inset(77)
            $0.height.equalTo(1)
        }
        
        loginDescribeLabel.snp.makeConstraints {
            $0.top.equalTo(loginTitleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(loginTitleLabel)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(77)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
        }
        
    }
}
