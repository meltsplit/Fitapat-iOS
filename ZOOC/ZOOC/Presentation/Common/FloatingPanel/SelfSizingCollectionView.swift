//
//  SelfSizingTableView.swift
//  ZOOC
//
//  Created by 장석우 on 2023/09/02.
//

import UIKit

final class SelfSizingCollectionView: UICollectionView {
    private let maxHeight: CGFloat
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: contentSize.width, height: min(contentSize.height, maxHeight))
    }
    
    init(maxHeight: CGFloat, layout: UICollectionViewLayout) {
        self.maxHeight = maxHeight
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
