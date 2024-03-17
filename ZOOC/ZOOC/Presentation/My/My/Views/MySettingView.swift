//
//  settingMenuTableView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/02.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class MySettingView: UITableView {
    
    //MARK: - Properties
    
    private var mySettingData: [MySettingModel] = MySettingModel.settingData
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)

        register()
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Custom Method
    
    private func register() {
        self.dataSource = self
        
        self.register(
            MySettingTableViewCell.self,
            forCellReuseIdentifier: MySettingTableViewCell.cellIdentifier
        )
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.rowHeight = 62
            $0.isScrollEnabled = false
        }
    }
}

//MARK: - UITableViewDataSource

extension MySettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySettingData.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MySettingTableViewCell.cellIdentifier, for: indexPath)
                as! MySettingTableViewCell
        cell.dataBind(mySettingData[indexPath.row])
        return cell
    }
}
