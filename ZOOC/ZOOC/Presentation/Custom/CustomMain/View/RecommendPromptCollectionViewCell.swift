//
//  RecommendPromptCollectionViewCell.swift
//  ZOOC
//
//  Created by 장석우 on 1/31/24.
//

import UIKit

import Then
import SnapKit

final class RecommendPromptCollectionViewCell: UICollectionViewCell {

    
    override var isSelected: Bool {
        didSet {
            if isSelected { Haptic.impact(.light).run() }
        }
    }
    
    //MARK: - UI Components
    
    private let imageView = UIImageView()
    
    private let promptLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        setBorder(width: 1, color: .zw_brightgray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func style() {
        contentView.backgroundColor = .zw_white
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        promptLabel.do {
            $0.font = .zw_Subhead4
            $0.textColor = .zw_black
        }
        
    }
    
    private func hierarchy() {
        
        contentView.addSubviews(imageView,
                                promptLabel)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(80)
        }
        

        promptLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            
        }
    }
    
    //MARK: - Public Method
    
    func updateUI(_ data: ( CustomKeywordType, RecommendKeywordResult)) {
        
        let type = data.0
        let result = data.1
        
        let 있어요 = (type == .accesorry) ? " 있어요" : ""
        promptLabel.text = result.keywordKo + 있어요
        imageView.kfSetImage(with: result.image)
    }
}
