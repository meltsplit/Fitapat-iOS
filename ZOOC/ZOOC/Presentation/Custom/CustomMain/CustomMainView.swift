//
//  CustomMakePromptView.swift
//  ZOOC
//
//  Created by 장석우 on 12/16/23.
//

import UIKit

import SnapKit
import Then

final class CustomMainView: UIView {
    
    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView()
    private let topShadowView = InnerShadowView(edgePoint: .bottom)
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let petImageView = UIImageView(image: .defaultDog)
    
    let accButton = CustomKeywordButton(type: .accesorry)
    let bgButton = CustomKeywordButton(type: .background)
    let outfitButton = CustomKeywordButton(type: .outfit)
    
    let doneButton = FapBottomButton(title: "커스텀 완료")
    
    
    private let l1hStackView = UIStackView()
    private let l1_1 = PetNameLabel()
    let bgPromptLabel = PromptLabel(.background)
    private let l1_2 = UILabel()
    
    private let l2hStackView = UIStackView()
    let outfitPromptLabel = PromptLabel(.outfit)
    private let l2_1 = UILabel()
    
    private let l3hStackView = UIStackView()
    let accPromptLabel = PromptLabel(.accesorry)
    private let l3_1 = UILabel()
    
    private let promptShadowView = InnerShadowView(alpha: 0.6)
    private let promptVStackView = UIStackView()
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hieararchy()
        layout()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method

    private func style() {

        backgroundImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.text = String(localized: "커스텀을 원하는 키워드를 선택해주세요")
            $0.font = .zw_Subhead1
            $0.textColor = .zw_white
        }
        
        descriptionLabel.do {
            $0.text = String(localized: "배경, 머리, 옷를 원하는대로 꾸밀 수 있어요")
            $0.font = .zw_Body1
            $0.textColor = .zw_white
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        petImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        promptVStackView.do {
            $0.backgroundColor = .clear
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 18
        }
        
        l1hStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 10
        }
        
        l2hStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 10
        }
        
        l3hStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 10
        }
        
        l1_1.do {
            $0.text = "{pet}\(조사.이가.서식)"
            $0.font = .pretendard(font: .light, size: 22)
            $0.textColor = .zw_white
            $0.setPetNameLabelStyle(targetString: ["{pet}"],
                                 color: .zw_white,
                                 font: .pretendard(font: .bold,
                                                   size: 22))
        }
        
        l1_2.do {
            $0.text = "에서"
            $0.font = .pretendard(font: .light, size: 22)
            $0.textColor = .zw_white
        }
        
        l2_1.do {
            $0.text = "을 입고"
            $0.font = .pretendard(font: .light, size: 22)
            $0.textColor = .zw_white
            $0.setAttributeLabel(targetString: ["입고"],
                                 color: .zw_white,
                                 font: .pretendard(font: .bold,
                                                   size: 22))
        }
        
        l3_1.do {
            $0.text = "있어요"
            $0.font = .pretendard(font: .light, size: 22)
            $0.textColor = .zw_white
        }
    }
    
    private func hieararchy() {
        
        self.addSubviews(
            backgroundImageView,
            topShadowView,
            titleLabel,
            descriptionLabel,
            petImageView,
            promptShadowView,
            promptVStackView,
            accButton,
            outfitButton,
            bgButton,
            doneButton
        )
        
        
        promptVStackView.addArrangedSubViews(
            l1hStackView,
            l2hStackView,
            l3hStackView
        )
        
        l1hStackView.addArrangedSubViews(l1_1, bgPromptLabel, l1_2)
        l2hStackView.addArrangedSubViews(outfitPromptLabel, l2_1)
        l3hStackView.addArrangedSubViews(accPromptLabel, l3_1)
        
    }
    
    private func layout() {
        
        backgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(doneButton)
        }
        
        topShadowView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        petImageView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        petImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalTo(promptVStackView.snp.top)
        }
        
        bgButton.snp.makeConstraints {
            $0.centerX.equalTo(petImageView).offset(-93 * Device.width / 376)
            $0.centerY.equalTo(petImageView).offset(-120 * Device.width / 376)
            $0.height.equalTo(36)
        }
        
        outfitButton.snp.makeConstraints {
            $0.centerX.equalTo(petImageView).offset(88 * Device.width / 376)
            $0.centerY.equalTo(petImageView).offset(-9 * Device.width / 376)
            $0.height.equalTo(36)
        }
        
        accButton.snp.makeConstraints {
            $0.centerX.equalTo(petImageView).offset(-91 * Device.width / 376)
            $0.centerY.equalTo(petImageView).offset(72 * Device.width / 376)
            $0.height.equalTo(36)
        }
        
        promptShadowView.snp.makeConstraints {
            $0.height.equalToSuperview().dividedBy(2)
            $0.bottom.equalTo(doneButton.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        promptVStackView.snp.makeConstraints {
            $0.bottom.equalTo(doneButton.snp.top).offset(-40)
            $0.horizontalEdges.equalToSuperview().inset(23)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        
    }
    
    func updateBackgroundImage(_ imageURL: String) {
        backgroundImageView.kfSetImage(with: imageURL, placeholder: .defaultImageBlack)
    }
    
    func updatePromptLabelUI(_ data: (CustomKeywordType, PromptDTO?)) {
        let type = data.0
        let prompt = data.1?.keywordKo
        
        switch type {
        case .accesorry:
            accPromptLabel.dataBind(prompt)
            accButton.updateUI(prompt)
        case .background:
            bgPromptLabel.dataBind(prompt)
            bgButton.updateUI(prompt)
        case .outfit:
            outfitPromptLabel.dataBind(prompt)
            outfitButton.updateUI(prompt)
        }
    }
    
    func update을를(_ 을or를: String) {
        l2_1.text = 을or를 + " 입고"
        l2_1.setAttributeLabel(targetString: ["입고"],
                               color: .zw_white,
                               font: .pretendard(
                                font: .bold,
                                size: 22))
    }
}
