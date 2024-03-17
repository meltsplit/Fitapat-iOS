//
//  BasePaddingLabel.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/27.
//

import UIKit

class BasePaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 16.0, left: 18.0, bottom: 16.0, right: 16.0)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    convenience init(leftPadding: CGFloat) {
        self.init()
        self.padding = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
