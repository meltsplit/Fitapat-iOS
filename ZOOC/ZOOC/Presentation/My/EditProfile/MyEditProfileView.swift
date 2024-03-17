//
//  EditProfileView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/04.
//

import UIKit

import SnapKit
import Then

final class MyEditProfileView: UIView {
    
    //MARK: - UI Components

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var profileImageButton = UIButton()
    private let cameraIconImageView = UIImageView()
    
    private let nameLabel = UILabel()
    private let requiredInputImageView = UIView()
    var nameTextField = ZoocEditTextField(textFieldType: .profile)
    
    private let breedLabel = UILabel()
    var breedTextField = ZoocEditTextField(textFieldType: .breed)
    
    var editButton = UIButton()
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        profileImageButton.makeCornerRound(ratio: 2)
        cameraIconImageView.makeCornerRound(ratio: 2)
        requiredInputImageView.makeCornerRound(ratio: 2)
    }
    
    //MARK: - Custom Method
    
    private func style() {
        self.backgroundColor = .zw_background
        
        scrollView.showsVerticalScrollIndicator = false
        
        profileImageButton.do {
            $0.imageView?.contentMode = .scaleAspectFill
        }
        
        cameraIconImageView.do {
            $0.image = .zwImage(.btn_picture)
            $0.contentMode = .scaleAspectFill
        }
        
        nameLabel.do {
            $0.text = "이름"
            $0.textColor = .zw_darkgray
            $0.font = .zw_Subhead4
        }
        
        requiredInputImageView.do {
            $0.backgroundColor = .zw_point
        }
        
        nameTextField.do {
            $0.addLeftPadding(inset: 20)
            $0.font = .zw_Body1
            $0.textColor = .zw_black
            $0.setBorder(width: 1, color: .zw_brightgray)
        }
        
        breedLabel.do {
            $0.text = "종"
            $0.textColor = .zw_darkgray
            $0.font = .zw_Subhead4
        }
        
        breedTextField.do {
            $0.addLeftPadding(inset: 20)
            $0.font = .zw_Body1
            $0.textColor = .zw_black
            $0.setBorder(width: 1, color: .zw_brightgray)
        }
        
        editButton.do {
            $0.backgroundColor = .zw_black
            $0.titleLabel?.font = .zw_Subhead1
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }
    }
    
    private func hierarchy() {
        
        self.addSubviews(scrollView, editButton)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            profileImageButton,
            cameraIconImageView,
            nameLabel,
            requiredInputImageView,
            nameTextField,
            breedLabel,
            breedTextField
        )
    }
    
    private func layout() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(editButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }
        
        profileImageButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(28)
            $0.size.equalTo(90)
        }
        cameraIconImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageButton).offset(60)
            $0.leading.equalTo(profileImageButton).offset(68)
            $0.size.equalTo(30)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(36)
            $0.leading.equalTo(profileImageButton)
        }
        
        requiredInputImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(38)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(2)
            $0.size.equalTo(6)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }
        breedLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(24)
            $0.leading.equalTo(profileImageButton)
        }
        breedTextField.snp.makeConstraints {
            $0.top.equalTo(breedLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(50)
            $0.bottom.lessThanOrEqualToSuperview().inset(40)
        }
        
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
}

//MARK: - UpdateUI Method

extension MyEditProfileView {
    func updateUI(_ pet: PetResult) {
        updateNameTextField(pet.name)
        updateBreedTextField(pet.breed)
        updateProfileImageButtonUI(pet.photo)
    }
    
    func updateNameTextField(_ name: String?) {
        nameTextField.text = name
        nameTextField.updateTextField(name)
    }
    
    func updateBreedTextField(_ breed: String?) {
        breedTextField.text = breed
        breedTextField.updateTextField(breed)
    }
    
    func updateProfileImageButtonUI(_ imageUrl: String?) {
        guard let imageUrl else {
            profileImageButton.setImage(.zwImage(.default_profile), for: .normal)
            return
        }
        profileImageButton.kfSetButtonImage(url: imageUrl)
    }
    
    func updateEditButtonUI(_ canEdit: Bool) {
        let updateColor: UIColor = canEdit ? .zw_black : .zw_lightgray
        editButton.backgroundColor = updateColor
    }
}
