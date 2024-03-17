//
//  OnboardingAgreementTableHeaderView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

//MARK: - AllChekedButtonTappedDelegate

protocol AllChekedButtonTappedDelegate : AnyObject {
    func allCellButtonTapped()
}

final class OnboardingAgreementCollectionHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: AllChekedButtonTappedDelegate?
    
    //MARK: - UI Components
    
    private var allAgreementLabel = UILabel()
    public lazy var allCheckedButton = BaseButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        target()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func target() {
        self.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(headerViewDidTap)
            )
        )
        
        allCheckedButton.addTarget(
            self,
            action: #selector(headerViewDidTap),
            for: .touchUpInside
        )
    }
    
    private func style() {
        self.do {
            $0.makeCornerRound(radius: 2)
            $0.setBorder(width: 1.3, color: .zw_lightgray)
        }
        
        allAgreementLabel.do {
            $0.text = "전체 동의"
            $0.textColor = .zw_lightgray
            $0.font = .zw_Subhead3
            $0.textAlignment = .left
        }
        
        allCheckedButton.do {
            $0.setImage(.zwImage(.btn_checkbox), for: .normal)
            $0.setImage(.zwImage(.btn_checkbox_fill), for: .selected)
        }
    }
    
    private func hierarchy() {
        self.addSubviews(allAgreementLabel, allCheckedButton)
    }
    
    private func layout() {
        allAgreementLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        allCheckedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(36)
        }
    }
    
    //MARK: - Action Method
    
    @objc func headerViewDidTap() {
        delegate?.allCellButtonTapped()
    }
}

extension OnboardingAgreementCollectionHeaderView {
    func updateUI(_ isSelected: Bool) {
        allCheckedButton.isSelected = isSelected
        let updateColor: UIColor = isSelected ? .zw_point : .zw_lightgray
        allAgreementLabel.textColor = updateColor
        self.layer.borderColor = updateColor.cgColor
    }
}

