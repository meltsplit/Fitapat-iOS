//
//  MyView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/01.
//

import UIKit

import SnapKit
import Then

final class MyView: UIView  {
    
    //MARK: - UI Components
    
    internal var scrollView = UIScrollView()
    private let contentView = UIView()
    internal let profileView = MyProfileView()
    internal let noProfileView = MyNoProfileView()
    internal let settingView = MySettingView()
    internal let deleteAccountButton = UIButton()
    
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
    
    //MARK: - Custom Method
    
    private func style() {
        self.backgroundColor = .zw_background
        scrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
        deleteAccountButton.do {
            $0.setTitle("회원탈퇴", for: .normal)
            $0.titleLabel?.font = .zw_caption
            $0.titleLabel?.textAlignment = .left
            $0.setTitleColor(.zw_lightgray, for: .normal)
            $0.setUnderline()
        }
        profileView.isHidden = true
    }
    
    private func hierarchy() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            profileView,
            noProfileView,
            settingView,
            deleteAccountButton
        )
    }
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(182)
        }
        
        noProfileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(189)
        }
        
        settingView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(profileView)
            $0.bottom.equalTo(deleteAccountButton.snp.top).inset(12)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(settingView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
}

extension MyView {
    func updateUI(_ profile: PetResult?) {
        guard let profile else {
            noProfileView.isHidden = false
            profileView.isHidden = true
            return 
        }
        noProfileView.isHidden = true
        profileView.isHidden = false
        profileView.dataBind(profile)
    }
}
