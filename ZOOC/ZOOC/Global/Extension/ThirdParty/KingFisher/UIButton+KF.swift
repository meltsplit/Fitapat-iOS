//
//  UIButton+ kf.swift
//  ZOOC
//
//  Created by 장석우 on 11/6/23.
//

import UIKit
import Kingfisher

extension UIButton {
    
    func kfSetButtonImage(url : String) {
        if let url = URL(string: url) {
            kf.setImage(with: url,
                        for: .normal, placeholder: nil,
                        options: [.transition(.fade(1.0))], progressBlock: nil)
        }
    }
}

