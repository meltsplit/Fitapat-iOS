//
//  SettingMenuTableViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/02.
//

import UIKit

final class MySettingTableViewCell: UITableViewCell {
    
    //MARK: - UI Components
    
    public var menuLabel = UILabel()
    private let iconImageView = UIImageView()
    private var separatorLine = UIView()
    
    //MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellStyle()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func cellStyle() {
        self.do {
            $0.backgroundColor = .clear
            $0.selectionStyle = .none
        }
        contentView.do {
            $0.backgroundColor = .clear
        }
        menuLabel.do {
            $0.textColor = .zw_black
            $0.font = .zw_Body1
        }
        
        separatorLine.do {
            $0.backgroundColor = .zw_brightgray
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(
            menuLabel,
            iconImageView,
            separatorLine
        )
    }
    
    private func layout() {
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(10)
        }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(menuLabel.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(315)
            $0.height.equalTo(1)
        }
    }
    
    public func dataBind(_ data: MySettingModel) {
        menuLabel.text = data.title
        iconImageView.image = data.icon
    }
}

