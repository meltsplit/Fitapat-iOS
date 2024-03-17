//
//  AppInformationView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/03.
//

import UIKit

import SnapKit
import Then

final class MyAppInformationView: UIView {
    
    //MARK: - UI Components
    
    public var appInformationTableView = UITableView(frame: .zero, style: .plain)
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        register()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func register() {
        appInformationTableView.register(
            MyAppInformationTableViewCell.self,
            forCellReuseIdentifier: MyAppInformationTableViewCell.cellIdentifier)
        
        appInformationTableView.register(MyAppInformationHeaderView.self, forHeaderFooterViewReuseIdentifier: MyAppInformationHeaderView.cellIdentifier)
    }
    
    private func style() {
        self.backgroundColor = .zw_background
        
        appInformationTableView.do {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
        }
    }
    
    private func hierarchy() {
        self.addSubviews(appInformationTableView
        )
    }
    
    private func layout() {

        appInformationTableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
}
