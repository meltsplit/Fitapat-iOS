//
//  ConceptItemCollectionViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 12/14/23.
//

import UIKit

import SnapKit
import Then

final class CustomDetailKeywordPromptCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let keywordLabel = UILabel()
    private let promptLabel = UILabel()
    
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
        keywordLabel.do {
            $0.font = .zw_Body2
            $0.textColor = .zw_white
            $0.textAlignment = .left
        }
        
        promptLabel.do {
            $0.textColor = .zw_white
            $0.font = .zw_Body2
            $0.makeCornerRound(radius: 18)
            $0.setBorder(width: 1, color: .zw_white)
            $0.backgroundColor = .zw_white.withAlphaComponent(0.2)
        }
    }
    
    private func hieararchy() {
        contentView.addSubviews(keywordLabel, promptLabel)
    }
    
    private func layout() {
        keywordLabel.setContentHuggingPriority(.required, for: .vertical)
        keywordLabel.setContentCompressionResistancePriority(.required, for: .vertical) //TODO: 폰트 왜짤리냐 Back"g"round
        keywordLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        promptLabel.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.height.equalTo(36)
            $0.bottom.equalToSuperview()
        }
    }
    
    func dataBind(_ data: (CustomKeywordType, PromptDTO?)) {
        
        let keyword = data.0
        let prompt = data.1
        let 있어요 = (keyword == .accesorry) ? " 있어요" : ""
        
        keywordLabel.text = keyword.title
        guard let keywordKo = prompt?.keywordKo else { return }
        promptLabel.text = "    \(keywordKo+있어요)    "
    }
}
