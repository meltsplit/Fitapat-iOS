//
//  MyRegisterPetCollectionView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/11.
//



import UIKit

import SnapKit
import Then

final class MyRegisterPetView: UIView {
    
    // MARK: - Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let descriptionLabel = UILabel()
    private let subDescriptionLabel = UILabel()
    
    private let nameLabel = FapRequiredInputLabel(text: "이름")
    
    var nameTextField = ZoocEditTextField(textFieldType: .profile)
    private let breedLabel = UILabel()
    var breedTextField = ZoocEditTextField(textFieldType: .breed)
    var registerPetButton = UIButton()
    
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate()
        style()
        hierarchy()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Custom Method
    
    private func delegate() {
        nameTextField.zoocDelegate = self
        breedTextField.zoocDelegate = self
    }
    
    private func style() {
        scrollView.showsVerticalScrollIndicator = false
        
        descriptionLabel.do {
            $0.font = .zw_Subhead1
            $0.text = "반려동물의 정보를 입력해주세요"
            $0.textAlignment = .left
            $0.textColor = .zw_black
        }
        subDescriptionLabel.do {
            $0.font = .zw_Body1
            $0.text = "해당 정보는 상품 제작 및 관리에 활용돼요"
            $0.textColor = .zw_gray
            $0.textAlignment = .left
        }
        
        nameTextField.do {
            $0.placeholder = "사랑이"
            $0.setPlaceholderColor(color: .zw_lightgray)
        }
        breedLabel.do {
            $0.text = "종"
            $0.textColor = .zw_darkgray
            $0.font = .zw_Subhead4
        }
        breedTextField.do {
            $0.placeholder = "포메라니안"
            $0.setPlaceholderColor(color: .zw_lightgray)
        }
        registerPetButton.do {
            $0.backgroundColor = .zw_black
            $0.setTitle("반려동물 AI 모델 생성하기", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Subhead1
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }
    }
    
    private func hierarchy() {
        
        self.addSubviews(scrollView, registerPetButton)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            nameLabel,
            descriptionLabel,
            subDescriptionLabel,
            nameTextField,
            breedLabel,
            breedTextField
        )
    }
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(registerPetButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.leading.equalToSuperview().offset(28)
        }
        subDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(subDescriptionLabel.snp.bottom).offset(60)
            $0.leading.equalTo(descriptionLabel)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }
        breedLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(24)
            $0.leading.equalTo(descriptionLabel)
        }
        breedTextField.snp.makeConstraints {
            $0.top.equalTo(breedLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.lessThanOrEqualToSuperview().inset(40)
            $0.height.equalTo(50)
        }
        registerPetButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
}

extension MyRegisterPetView {
    func updateNameTextField(_ name: String?) {
        nameTextField.text = name
        nameTextField.updateTextField(name)
    }
    
    func updateBreedTextField(_ breed: String?) {
        breedTextField.text = breed
        breedTextField.updateTextField(breed)
    }
    
    func updateRegisterButtonUI(_ canRegister: Bool) {
        let updateColor: UIColor = canRegister ? .zw_black : .zw_lightgray
        registerPetButton.backgroundColor = updateColor
    }
}


extension MyRegisterPetView: ZoocEditTextFieldDelegate {
    func zoocTextFieldDidReturn(_ textField: ZoocEditTextField) {
        if textField == nameTextField {
            breedTextField.becomeFirstResponder()
        }
    }
}
