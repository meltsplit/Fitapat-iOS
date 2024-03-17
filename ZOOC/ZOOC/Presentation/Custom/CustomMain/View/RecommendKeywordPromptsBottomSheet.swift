//
//  RecommendKeywordPromptsBottomSheet.swift
//  ZOOC
//
//  Created by 장석우 on 1/31/24.
//

import UIKit

import SnapKit
import Then

final class RecommendKeywordPromptsBottomSheet: UIViewController, ScrollableViewController {
    
    //MARK: - UI Components
    
    private let keywordLabel = UILabel()
    let resetButton = UIButton()
    
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = SelfSizingCollectionView(maxHeight: Device.height * 0.7, layout: flowLayout)
    
    var scrollView: UIScrollView { collectionView }
    
    //MARK: - Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        register()
        style()
        hierarchy()
        layout()
    }

    
    //MARK: - Custom Method
    
    private func register() {
        collectionView.register(RecommendPromptCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendPromptCollectionViewCell.cellIdentifier)
        
    }

    
    
    private func style() {
        
        view.backgroundColor = .zw_background
        keywordLabel.do {
            $0.text = "키워드"
            $0.textColor = .zw_black
            $0.font = .zw_Subhead2
        }
        
        resetButton.do {
            $0.setTitle("키워드 비우기", for: .normal)
            $0.setTitleColor(.zw_lightgray, for: .normal)
            $0.titleLabel?.font = .zw_Subhead4
            $0.titleLabel?.asUnderLine("키워드 비우기")
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
        
        
    }
    
    private func hierarchy() {
        view.addSubviews(keywordLabel,
                         resetButton,
                         collectionView)
    }
    
    private func layout() {
        
        flowLayout.do {
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: Device.width - 28 * 2, height: 80)
            $0.minimumLineSpacing = 10
            $0.sectionInset = .init(top: 0, left: 0, bottom: 30, right: 0)
        }
        
        keywordLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30).priority(.required)
            $0.leading.equalToSuperview().inset(28)
        }
        
        resetButton.setContentCompressionResistancePriority(.required, for: .vertical)
        resetButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalTo(keywordLabel)
        }
        
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(20).priority(.required)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
        }
    }
    
    func updateUI(_ type: CustomKeywordType) {
        keywordLabel.text = "\(type.title) 키워드"
    }
    
}
