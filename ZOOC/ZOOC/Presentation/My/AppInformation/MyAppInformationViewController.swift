//
//  AppInformationViewController.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/04.
//

import UIKit

import SnapKit
import Then

final class MyAppInformationViewController: BaseViewController {
    
    //MARK: - Properties
    
    private lazy var appInformationView = MyAppInformationView()
    private let externalURLs = [ExternalURL.termsOfUse,
                                ExternalURL.privacyPolicy,
                                ExternalURL.consentMarketing]
    
    //MARK: - Life Cycle
    
    override func loadView() {
        self.view = appInformationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
    }
    
    //MARK: - Custom Method
    
    private func register() {
        appInformationView.appInformationTableView.delegate = self
        appInformationView.appInformationTableView.dataSource = self
    }
    
    //MARK: - Action Method
    
    @objc
    private func popToMyProfileView() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDelegate

extension MyAppInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 43
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentSafariViewController(externalURLs[indexPath.row])
    }
}

//MARK: - UITableViewDataSource

extension MyAppInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyAppInformationModel.appInformationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAppInformationTableViewCell.cellIdentifier, for: indexPath) as?
                MyAppInformationTableViewCell else { return UITableViewCell() }
        cell.dataBind(model: MyAppInformationModel.appInformationData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyAppInformationHeaderView.cellIdentifier) as? MyAppInformationHeaderView else { return UIView()}
        return header
    }
}
