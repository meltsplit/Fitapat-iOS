//
//  CommunityDetailView.swift
//  ZOOC
//
//  Created by 류희재 on 12/13/23.
//

import UIKit

import SnapKit
import Then

final class CustomDetailView: UIView {
    
    //MARK: - Properties
    
    private var paidUpState: Bool = false {
        didSet {
            paidupTag.isHidden = !paidUpState
        }
    }
    
    // MARK: - UI Components
    
    let customImageView = UIImageView()
    private let paidupTag = UIButton()
    private let petNameLabel = UILabel()
    private let conceptLabel = UILabel()
    private let imageTopShadowView = InnerShadowView(edgePoint: .bottom)
    let imageBottomShadowView = InnerShadowView()
    
    lazy var conceptItemCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomCollectionViewLayout.conceptDetail.createLayout()
    )
    let conceptDetailAIButton = FapBottomButton(title: "바로 적용하기")
    let saveImageButton = FapBottomButton(title: "이미지 저장")
    let albumDetailAIButton = FapBottomButton(title: "이 캐릭터로 {pet} 굿즈 구매")
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func register() {
        conceptItemCollectionView.register(
            CustomDetailKeywordPromptCell.self, forCellWithReuseIdentifier:
                CustomDetailKeywordPromptCell.cellIdentifier
        )
    }
    
    private func style() {
        paidupTag.do {
            $0.setTitle("구매완료", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Body3
            $0.titleLabel?.textAlignment = .center
            $0.setBorder(width: 1, color: .zw_white)
            $0.makeCornerRound(radius: 14)
            $0.isHidden = true
        }
        
        customImageView.do {
            $0.image = .defaultImageBlack
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        petNameLabel.do {
            $0.font = .zw_Subhead1
            $0.textAlignment = .left
            $0.textColor = .zw_white
        }
        
        conceptLabel.do {
            $0.font = .zw_Body1
            $0.textAlignment = .left
            $0.textColor = .zw_white
        }
        
        conceptItemCollectionView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
        }
        
        saveImageButton.do {
            $0.setBackgroundColor(.zw_white, for: .normal)
            $0.setTitleColor(.zw_black, for: .normal)
        }
    }
    
    private func hieararchy() {
        addSubviews(customImageView,
                    imageTopShadowView,
                    imageBottomShadowView,
                    paidupTag,
                    petNameLabel,
                    conceptLabel,
                    conceptItemCollectionView,
                    conceptDetailAIButton,
                    saveImageButton,
                    albumDetailAIButton
        )
    }
    
    private func layout() {
        customImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(conceptDetailAIButton.snp.top)
        }
        
        imageTopShadowView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(136)
        }
        
        imageBottomShadowView.snp.makeConstraints {
            $0.bottom.equalTo(conceptDetailAIButton.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(373)
        }
        
        conceptDetailAIButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(77)
        }
        
        saveImageButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalToSuperview().multipliedBy(123 / Device.width)
            $0.bottom.equalToSuperview()
        }
        
        albumDetailAIButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(saveImageButton)
            $0.leading.equalTo(saveImageButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        
        petNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(conceptItemCollectionView.snp.top).offset(-28)
            $0.leading.equalToSuperview().offset(28)
        }
        
        conceptLabel.snp.makeConstraints {
            $0.top.equalTo(petNameLabel)
            $0.leading.equalTo(petNameLabel.snp.trailing).offset(4)
        }
        
        paidupTag.snp.makeConstraints {
            $0.top.equalTo(petNameLabel)
            $0.leading.equalToSuperview().offset(28)
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
        
        conceptItemCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(87)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension CustomDetailView {
    func switchUI(_ detailType: CustomType) {
        var switchView = [conceptItemCollectionView, imageBottomShadowView]
        switch detailType {
        case .concept:
            [petNameLabel, conceptLabel].forEach { switchView.append($0) }
        case .character:
            if paidUpState { switchView.append(paidupTag) }
        }
        switchView.forEach { $0.isHidden.toggle() }
    }
    
    func setupUI(_ detailType: CustomType) {
        [petNameLabel, conceptLabel, conceptDetailAIButton].forEach {
            $0.isHidden = detailType.isHidden
        }
        
        [saveImageButton, albumDetailAIButton].forEach {
            $0.isHidden = !detailType.isHidden
        }
    }
    
    func updateUI(_ data: DetailCustomEntity) {
        petNameLabel.text = data.characterData.petName
        conceptLabel.text = "| \(data.concept.name)"
        customImageView.kfSetImage(with: data.characterData.image,
                                   placeholder: .defaultImageBlack)
        paidUpState = data.hasPurchased
        
        conceptItemCollectionView.snp.remakeConstraints {
            $0.bottom.equalToSuperview().inset(87)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(data.keywordData.count * 86)
        }
    }
}

