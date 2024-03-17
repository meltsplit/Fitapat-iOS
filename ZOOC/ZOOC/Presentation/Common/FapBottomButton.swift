//
//  FapBottomButton.swift
//  ZOOC
//
//  Created by 장석우 on 12/17/23.
//

import UIKit

final class FapBottomButton: PetNameButton {
    
    init(title: String) {
        
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        
        self.setBackgroundColor(.zw_lightgray, for: .disabled)
        self.setBackgroundColor(.zw_black, for: .normal)
        self.setTitleColor(.zw_white, for: .normal)
        self.titleLabel?.font = .zw_Subhead1
        self.titleLabel?.textAlignment = .center
        self.contentEdgeInsets = .init(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

