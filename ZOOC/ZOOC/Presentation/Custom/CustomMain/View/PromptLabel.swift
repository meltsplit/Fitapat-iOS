//
//  PromptLabel.swift
//  ZOOC
//
//  Created by 장석우 on 1/30/24.
//

import UIKit

import SnapKit
import Then

final class PromptLabel: UIView {
    
    //MARK: - Properties
    
    private let type: CustomKeywordType
    private var prompt: String? {
        didSet {
            updateUI(prompt)
        }
    }
    
    //MARK: - UI Components
    
    private let plusImageView = UIImageView()
    private let promptLabel = UILabel()
    
    private let underLineView = UIView()
    
    private let hStackView = UIStackView()
    
    //MARK: - Life Cycle
    
    init(_ type: CustomKeywordType) {
        self.type = type
        self.prompt = nil
        
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Method
    
    private func style() {
        underLineView.do {
            $0.backgroundColor = .zw_brightgray
        }
        
        promptLabel.do {
            $0.textColor = .zw_brightgray
            $0.font = .pretendard(font: .regular, size: 18)
            $0.text = type.title
        }
        
        hStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 4
        }
        
        plusImageView.do {
            $0.image = .icPlusMini
            $0.contentMode = .scaleAspectFit
        }
        
    }
    
    private func hierarchy() {
        self.addSubviews(hStackView,
                         underLineView)
        
        hStackView.addArrangedSubViews(plusImageView, promptLabel)
    }
    
    private func layout() {
        
        hStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(underLineView.snp.top).offset(-5)
        }
        
        underLineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        plusImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
    
    private func updateUI(_ prompt: String?) {
        
        let color: UIColor
        let font: UIFont
        let hidden: Bool
        let text: String
        
        if prompt == nil {
            color = .zw_brightgray
            font = .pretendard(font: .regular, size: 18)
            hidden = false
            text = type.title
        } else {
            text = prompt!
            color = .zw_white
            font = .pretendard(font: .semiBold, size: 18)
            hidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.type = CATransitionType.fade
            animation.subtype = CATransitionSubtype.fromTop
            self.plusImageView.isHidden = hidden
            self.promptLabel.textColor = color
            self.promptLabel.font = font
            self.underLineView.backgroundColor = color
            self.promptLabel.text = text
            animation.duration = 0.4
            self.layer.add(animation, forKey: CATransitionType.fade.rawValue)
        }
        
    }
    
    //MARK: - Public Method
    
    func dataBind(_ prompt: String?) {
        self.prompt = prompt
    }
    
    
    
}
