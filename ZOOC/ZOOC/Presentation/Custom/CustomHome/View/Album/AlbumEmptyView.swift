//
//  AlbumEmptyView.swift
//  ZOOC
//
//  Created by 류희재 on 1/30/24.
//

import UIKit

import SnapKit
import Then

final class AlbumEmptyView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    lazy var customAIButton = PetNameButton()
    
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
            $0.text = "아직 만든 AI 캐릭터가 없어요"
            $0.font = .zw_head1
            $0.textAlignment = .center
            $0.textColor = .zw_black
        }
        descriptionLabel.do {
            $0.text = "원하는대로 만드는 커스텀 AI를 경험해보세요"
            $0.font = .zw_Body1
            $0.textAlignment = .center
            $0.textColor = .zw_gray
        }
        customAIButton.do {
            $0.setTitle("셀프 커스텀 하러가기", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Subhead3
            $0.backgroundColor = .zw_black
        }
    }
    
    private func hieararchy() {
        self.addSubviews(titleLabel, descriptionLabel, customAIButton)
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(224)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        customAIButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(48)
            $0.height.equalTo(51)
        }
    }
}
