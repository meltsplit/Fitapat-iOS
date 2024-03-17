//
//  MyAppInformationHeaderView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/05/07.
//

import UIKit

final class MyAppInformationHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - UI Components
    
    private var currentVersionTitleLabel = UILabel()
    private var currentVersionLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func style() {
        currentVersionTitleLabel.do {
            $0.font = .zw_Body1
            $0.text = "현재 버전"
            $0.textColor = .zw_black
        }
        
        currentVersionLabel.do {
            $0.font = .zw_Body2
            $0.text = Device.getCurrentVersion()
            $0.textColor = .zw_darkgray
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(currentVersionTitleLabel, currentVersionLabel)
    }
    
    private func layout() {
        currentVersionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.leading.equalToSuperview().offset(10)
        }
        
        currentVersionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview()
        }
    }
}


