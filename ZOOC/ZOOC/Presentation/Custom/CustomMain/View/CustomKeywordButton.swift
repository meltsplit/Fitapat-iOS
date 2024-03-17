//
//  CustomKeywordButton.swift
//  ZOOC
//
//  Created by 장석우 on 2/1/24.
//

import UIKit

final class CustomKeywordButton: UIButton {
    
    let type: CustomKeywordType
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    init(type: CustomKeywordType) {
        self.type = type
        super.init(frame: .zero)

        
        var config = UIButton.Configuration.plain()
        //config.background.customView = blurView
        backgroundColor = .zw_white.withAlphaComponent(0.25)
        
        setBorder(width: 1, color: .zw_white)
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        config.image = .icPlusMini.withTintColor(.zw_white)
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 14,
            bottom: 12,
            trailing: 16
        )
        
        
        var titleAttr = AttributedString.init(type.title)
        titleAttr.font = .gmarket(font: .medium, size: 12)
        titleAttr.foregroundColor = .zw_white
        config.attributedTitle = titleAttr
        
        self.configuration = config

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateUI(_ prompt: String?) {
        let borderColor: UIColor = prompt == nil ? .zw_white : .zw_point
        let textColor: UIColor = prompt == nil ? .zw_white : .zw_point
        let buttonImage: UIImage = prompt == nil ? .icPlusMini.withTintColor(.zw_white) : .icMinicheck
        let bgdColor: UIColor = prompt == nil ? .zw_white.withAlphaComponent(0.25) : .zw_white
        let blurHidden: Bool = prompt != nil

        setBorder(width: 1, color: borderColor)
        
        var titleAttr = AttributedString.init(type.title)
        titleAttr.font = .gmarket(font: .medium, size: 12)
        titleAttr.foregroundColor = textColor
        configuration?.attributedTitle = titleAttr
        configuration?.image = buttonImage
        blurView.isHidden = blurHidden
        backgroundColor = bgdColor
        
    }
    
    
}
