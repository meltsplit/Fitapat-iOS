//
//  NetworkAlertView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/19.
//

import UIKit

import SnapKit

final class NetworkAlertView: UIView {
    
    private let alertView = UIView()
    private let dimmedView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var updateButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        target()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func target() {
        updateButton.addTarget(self, action: #selector(updateButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        backgroundColor = .clear
        
        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
            $0.alpha = 1
        }
        
        dimmedView.do {
            $0.backgroundColor = .black
            $0.alpha = 0.55
        }
        
        titleLabel.do {
            $0.text = "네트워크가 원활하지 않습니다."
            $0.backgroundColor = .white
            $0.font = .zw_Subhead3
            $0.textColor = .zw_black
        }
        
        descriptionLabel.do {
            $0.text = "인터넷 연결 상태를 확인해주세요."
            $0.font = .zw_Body2
            $0.textColor = .zw_gray
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        updateButton.do {
            $0.setTitle("다시 시도", for: .normal)
            $0.setBackgroundColor(.zw_black, for: .normal)
            $0.setBackgroundColor(.zw_darkgray, for: .highlighted)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        }
    }
    
    private func hierarchy() {
        addSubviews(dimmedView,alertView)
        alertView.addSubviews(titleLabel, descriptionLabel, updateButton)
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
        
        updateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
    }
    
    //MARK: - Action Method
    
    @objc func updateButtonDidTap() {
          // 특정 API를 재시도할 수 있을까
    }
}



