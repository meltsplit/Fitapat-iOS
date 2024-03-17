//
//  VersionUpdateAlertViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/16.
//


import UIKit

import SnapKit
import Then

protocol VersionAlertViewControllerDelegate: AnyObject {
    func updateButtonDidTap(_ versionState: VersionState)
    func exitButtonDidTap()
}

final class VersionAlertViewController: UIViewController {
    
    //MARK: - Properties
    
    var versionState: VersionState {
        didSet{
            updateUI()
        }
    }
    
    var appID: String = "1669547675"
    
    weak var delegate: VersionAlertViewControllerDelegate?
    
    //MARK: - UI Components
    
    private let alertView = UIView()
    private let dimmedView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var exitButton = UIButton()
    private lazy var updateButton = UIButton()
    private lazy var hStackView = UIStackView()
    
    //MARK: - Life Cycle
    
    init(_ state: VersionState) {
        self.versionState = state
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
        
        style()
        hierarchy()
        layout()
        updateUI()
        
    }
    
    //MARK: - Custom Method
    
    private func target() {
        updateButton.addTarget(self, action: #selector(updateButtonDidTap), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        view.backgroundColor = .clear
        
        alertView.do {
            $0.backgroundColor = .zw_white
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
            $0.alpha = 1
        }
        
        dimmedView.do {
            $0.backgroundColor = .black
            $0.alpha = 0.45
        }
        
        titleLabel.do {
            $0.text = "새로운 버전이 출시됐어요☺️"
            $0.backgroundColor = .white
            $0.font = .zw_Subhead1
            $0.textColor = .zw_black
        }
        
        descriptionLabel.do {
            $0.text = "지금 앱스토어에서 업데이트 해보세요!"
            $0.font = .zw_Body2
            $0.textColor = .zw_gray
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        exitButton.do {
            $0.setTitle("나중에", for: .normal)
            $0.backgroundColor = .zw_white
            $0.setTitleColor(.zw_black, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zw_Subhead3
        }
        
        updateButton.do {
            $0.setTitle("업데이트", for: .normal)
            $0.backgroundColor = .zw_black
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zw_Subhead3
        }
        
        hStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
    
    private func hierarchy() {
        view.addSubviews(dimmedView,alertView)
        alertView.addSubviews(titleLabel, descriptionLabel, hStackView)
        hStackView.addArrangedSubViews(exitButton, updateButton)
    }
    
    private func layout() {
        alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(299)
            $0.height.equalTo(180)
        }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(41)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        hStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        exitButton.snp.makeConstraints {
            $0.width.equalTo(120)
        }
    }
    
    private func updateUI() {
        switch versionState {
        case .mustUpdate:
            exitButton.isHidden = true
        default:
            exitButton.isHidden = false
        }
    }
    
    //MARK: - Action Method
    
    @objc func updateButtonDidTap() {
        delegate?.updateButtonDidTap(versionState)
    }
    
    @objc func exitButtonDidTap() {
        delegate?.exitButtonDidTap()
        self.dismiss(animated: false)
    }
}

