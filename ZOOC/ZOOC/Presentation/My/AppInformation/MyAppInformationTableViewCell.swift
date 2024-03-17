//
//  AppInformationTableViewCell.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/03.
//

import UIKit

final class MyAppInformationTableViewCell: UITableViewCell {
    
    //MARK: - UI Components
    
    private var separatorLine = UIView()
    public var appInformationButton = UIButton()
    public var appInformationLabel = UILabel()
    
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
        contentView.backgroundColor = .zw_background
        
        separatorLine.do {
            $0.backgroundColor = .zw_brightgray
        }
        
        appInformationLabel.do {
            $0.textColor = .zw_black
            $0.font = .zw_Body1
        }
    }
    
    private func hierarchy() {
        contentView.addSubviews(separatorLine, appInformationLabel)
    }
    
    private func layout() {
        separatorLine.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        appInformationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    public func dataBind(model: MyAppInformationModel) {
        appInformationLabel.text = model.title
    }
}


