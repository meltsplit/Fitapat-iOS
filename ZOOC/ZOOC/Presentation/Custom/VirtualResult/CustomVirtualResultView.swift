//
//  CustomResultView.swift
//  ZOOC
//
//  Created by 류희재 on 12/16/23.
//

import UIKit

import SnapKit
import Then

final class CustomVirtualResultView: UIView {
    
    // MARK: - Properties
    
    let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let resultImageView = UIImageView()
    private let topShadowView = InnerShadowView(alpha: 1, edgePoint: .bottom)
    private let bottomShadowView = InnerShadowView(alpha: 1, edgePoint: .top)
    
    private let resultContainerView = UIView()
    private let describeLabel = UILabel()
    private let subDescribeLabel = PetNameLabel()
    private let lineView = UIView()
    
    
    private let popularProductLabel = UILabel()
    private let popularProductDescriptionLabel = PetNameLabel()
    lazy var productCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init()
    )
    
    let retryButton = UIButton()
    let applyButton = PetNameButton()
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        register()
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func register() {
        productCollectionView.register(
            CustomVirtualResultCollectionViewCell.self,
            forCellWithReuseIdentifier:
                CustomVirtualResultCollectionViewCell.cellIdentifier
        )
    }
    
    private func style() {
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
            $0.contentInsetAdjustmentBehavior = .never
            $0.backgroundColor = .black
        }
        
        contentView.do {
            $0.backgroundColor = .black
        }
        
        resultImageView.do {
            $0.image = .default
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        describeLabel.do {
            $0.text = "멋진 결과물이 나왔어요"
            $0.font = .zw_Subhead1
            $0.textColor = .zw_white
        }
        
        subDescribeLabel.do {
            $0.text = "{pet}에게 적용하고 싶다면 커스텀 굿즈를 구매해보세요"
            $0.font = .zw_Body2
            $0.textColor = .zw_white
        }
        
        lineView.do {
            $0.backgroundColor = .zw_background
        }
        
        popularProductLabel.do {
            $0.text = "인기 커스텀 굿즈"
            $0.font = .zw_Subhead1
            $0.textColor = .zw_white
        }
        
        popularProductDescriptionLabel.do {
            $0.text = "{pet}\(조사.과와.서식) 닮은 친구들이 가장 많이 구매한 제품이에요"
            $0.font = .zw_Body2
            $0.textColor = .zw_white
        }
        
        productCollectionView.do {
            let width = 280 * Device.width / 375
            let inset = (Device.width - width) / 2
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(
                width: width,
                height: 380
            )
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .init(top: 0, 
                                        left: inset,
                                        bottom: 0,
                                        right: inset)
            
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.decelerationRate = .fast
        }
        
        retryButton.do {
            $0.setTitle("다시 만들기", for: .normal)
            $0.setTitleColor(.zw_point, for: .normal)
            $0.backgroundColor = .zw_background
            $0.titleLabel?.font = .zw_Subhead1
            $0.titleLabel?.textAlignment = .center
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }
        
        applyButton.do {
            $0.setTitle("{pet}에게 적용하기", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.backgroundColor = .zw_point
            $0.titleLabel?.font = .zw_Subhead1
            $0.titleLabel?.textAlignment = .center
            $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
        }

    }
    
    private func hieararchy() {
        
        addSubviews(scrollView,
                    retryButton,
                    applyButton)
        
        scrollView.addSubviews(contentView,
                               resultImageView)
        
        resultImageView.addSubviews(
            topShadowView,
            bottomShadowView,
            describeLabel,
            subDescribeLabel,
            lineView)
        
        contentView.addSubviews(
            resultContainerView,
            popularProductLabel,
            popularProductDescriptionLabel,
            productCollectionView
        )
    }
    
    private func layout() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(retryButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        resultImageView.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(self.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(resultContainerView.snp.bottom)
        }
        
        topShadowView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        bottomShadowView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        resultContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Device.width * 1.5)
        }
        
        describeLabel.snp.makeConstraints {
            $0.bottom.equalTo(subDescribeLabel.snp.top).offset(-6)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        subDescribeLabel.snp.makeConstraints {
            $0.bottom.equalTo(lineView.snp.top).offset(-28)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalTo(resultImageView).offset(-24)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(1)
        }
        
        popularProductLabel.snp.makeConstraints {
            $0.top.equalTo(resultContainerView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        popularProductDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(popularProductLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalTo(popularProductLabel)
        }
        
        productCollectionView.snp.makeConstraints {
            $0.top.equalTo(popularProductDescriptionLabel.snp.bottom).offset(80)
            $0.horizontalEdges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(380)
            $0.bottom.equalToSuperview().inset(77)
        }
        
        retryButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalToSuperview().multipliedBy(142 / Device.width)
            $0.bottom.equalToSuperview()
        }
        
        applyButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(retryButton)
            $0.leading.equalTo(retryButton.snp.trailing)
            $0.trailing.equalToSuperview()
        }
    }
    
    func updateUI(_ imageURL: String) {
        resultImageView.kfSetImage(with: imageURL, placeholder: .defaultImageBlack)
    }
}





