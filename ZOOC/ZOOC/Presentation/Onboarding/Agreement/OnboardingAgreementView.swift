//
//  OnboardingAgreementView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

final class OnboardingAgreementView: UIView {

    //MARK: - UI Components
    
    private let agreeTitleLabel = UILabel()
    public lazy var agreementCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    public lazy var signUpButton = UIButton()
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func register() {
        agreementCollectionView.register(
            OnboardingAgreementCollectionViewCell.self,
            forCellWithReuseIdentifier: OnboardingAgreementCollectionViewCell.cellIdentifier)
        
        agreementCollectionView.register(
            OnboardingAgreementCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: OnboardingAgreementCollectionHeaderView.reuseCellIdentifier)
    }
    
    private func style() {
        self.backgroundColor = .zw_background
        
        agreeTitleLabel.do {
            $0.text = "더 나은 서비스 제공을 위해 \n약관동의가 필요해요"
            $0.textColor = .zw_black
            $0.textAlignment = .left
            $0.font = .pretendard(font: .regular, size: 24)
            $0.numberOfLines = 2
            $0.setLineSpacing(spacing: 4)
            $0.setAttributeLabel(
                targetString: ["약관동의"],
                color: .zw_black,
                font: .pretendard(font: .bold, size: 24),
                spacing: 4
            )
        }
        
        agreementCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(
                width: 319,
                height: 36
            )
            layout.minimumLineSpacing = 4
            layout.headerReferenceSize = CGSize(
                width: 319,
                height: 60
            )
            layout.sectionInset = UIEdgeInsets(
                top: 24,
                left: 0,
                bottom: 0,
                right: 0
            )
            $0.collectionViewLayout = layout
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        signUpButton.do {
            $0.backgroundColor = .zw_lightgray
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Subhead1
            $0.titleLabel?.textAlignment = .center
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }
    }
    private func hierarchy() {
        self.addSubviews(
            agreeTitleLabel,
            agreementCollectionView,
            signUpButton
        )
    }
    private func layout() {
        agreeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(68)
        }
        agreementCollectionView.snp.makeConstraints {
            $0.top.equalTo(agreeTitleLabel.snp.bottom).offset(43)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.equalTo(signUpButton.snp.top)
        }
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
}
