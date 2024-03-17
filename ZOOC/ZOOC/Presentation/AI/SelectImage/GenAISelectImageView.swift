//
//  GenAISelectImageView.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/18.
//

import UIKit

import SnapKit
import Then

final class GenAISelectImageView: UIView {
    
    //MARK: - UI Components
    
    public lazy var reSelectedImageButton = UIButton()
    public lazy var petImageCollectionView: UICollectionView = {
        var width = Device.width - 43 - 43 - 10 - 10
        width /= 3
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.alwaysBounceVertical = true
        cv.showsVerticalScrollIndicator = true
        cv.contentInset = .init(top: 0,
                                left: 43,
                                bottom: 0,
                                right: 43)
        return cv
    }()
    
    private let titleLabel = UILabel()
    public let subTitleLabel = UILabel()
    public lazy var generateAIModelButton = UIButton()
    
    public let activityIndicatorView = UIActivityIndicatorView(style: .large)
    public let buttonActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    //MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method
    
    private func register() {
        petImageCollectionView.register(GenAIPetImageCollectionViewCell.self, forCellWithReuseIdentifier: GenAIPetImageCollectionViewCell.cellIdentifier)
    }
    
    private func style() {
        self.backgroundColor = .zw_background
        
        titleLabel.do {
            $0.text = "아래 사진으로 확정하시나요?"
            $0.textColor = .zw_black
            $0.font = .zw_Subhead1
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.text = "선택한 사진으로 AI 모델 생성이 진행돼요"
            $0.textColor = .zw_gray
            $0.font = .zw_Body1
            $0.textAlignment = .center
        }
        
        reSelectedImageButton.do {
            $0.setTitle("사진을 다시 고를래요", for: .normal)
            $0.setTitleColor(.zw_gray, for: .normal)
            $0.titleLabel?.font = .zw_Body2
            $0.titleLabel?.textAlignment = .center
            $0.setUnderline()
        }
        
        generateAIModelButton.do {
            $0.isEnabled = false
            $0.setBackgroundColor(.zw_darkgray, for: .disabled)
            $0.setBackgroundColor(.zw_black, for: .normal)
            $0.setTitle("사진 업로드 완료", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Subhead1
            $0.titleLabel?.textAlignment = .center
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }
        
        buttonActivityIndicatorView.do {
            $0.hidesWhenStopped = true
            $0.color = .white
            $0.style = .medium

        }
    }
    
    private func hierarchy() {
        self.addSubviews(
            titleLabel,
            subTitleLabel,
            petImageCollectionView,
            reSelectedImageButton,
            generateAIModelButton,
            activityIndicatorView
        )
        
        generateAIModelButton.addSubview(buttonActivityIndicatorView)
        
    }
    
    
    private func layout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        petImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(reSelectedImageButton.snp.top).offset(-20)
        }
        
        reSelectedImageButton.snp.makeConstraints {
            $0.bottom.equalTo(generateAIModelButton.snp.top).offset(-24)
            $0.leading.trailing.equalToSuperview().inset(107)
            $0.height.equalTo(36)
        }
        
        generateAIModelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        buttonActivityIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-15)
        }
    }
}
