//
//  CustomTopView.swift
//  ZOOC
//
//  Created by 류희재 on 12/12/23.
//

import UIKit

import SnapKit
import Then

final class CustomTopView: UIView {
    
    // MARK: - UI Components
    
    lazy var conceptButton = UIButton()
    let conceptButtonUnderline = UIView()
    lazy var albumButton = UIButton()
    let albumButtonUnderline = UIView()
    
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
        conceptButton.do {
            $0.setTitle(String(localized: "컨셉"), for: .normal)
            $0.setTitleColor(.zw_lightgray, for: .normal)
            $0.setTitleColor(.zw_black, for: .selected)
            $0.backgroundColor = .clear
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zw_Subhead3
            $0.isSelected = true
        }
        
        conceptButtonUnderline.do {
            $0.backgroundColor = .zw_black
        }
        
        albumButton.do {
            $0.setTitle(String(localized: "앨범"), for: .normal)
            $0.setTitleColor(.zw_lightgray, for: .normal)
            $0.setTitleColor(.zw_black, for: .selected)
            $0.backgroundColor = .clear
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zw_Subhead3
            $0.isSelected = false
        }
        
        albumButtonUnderline.do {
            $0.backgroundColor = .zw_black
            $0.isHidden = true
        }
    }
    
    private func hieararchy() {
        self.addSubviews(
            conceptButton,
            albumButton,
            conceptButtonUnderline,
            albumButtonUnderline
        )
    }
    
    private func layout() {
        conceptButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(28)
        }
        
        conceptButtonUnderline.snp.makeConstraints {
            $0.centerX.equalTo(conceptButton)
            $0.width.equalTo(28)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().inset(1)
        }
        
        albumButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalTo(conceptButton.snp.trailing).offset(16)
        }
        
        albumButtonUnderline.snp.makeConstraints {
            $0.centerX.equalTo(albumButton)
            $0.bottom.equalToSuperview().inset(1)
            $0.width.equalTo(28)
            $0.height.equalTo(1)
        }
    }
}
