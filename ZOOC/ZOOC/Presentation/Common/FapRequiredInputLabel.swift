//
//  ZoocRequiredInputLabel.swift
//  ZOOC
//
//  Created by 류희재 on 2023/09/08.
//

import UIKit
import SnapKit

final class FapRequiredInputLabel: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .zw_Subhead4
        label.textColor = .zw_darkgray
        return label
    }()
    
    private let circle: UIView = {
        let view = UIView()
        view.backgroundColor = .zw_point
        return view
    }()
    
    //MARK: - Life Cycle

    
    convenience init(text: String) {
        self.init()
        
        label.text = text
        
        hierarchy()
        layout()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circle.makeCornerRound(ratio: 2)
    }
    
    //MARK: - Custom Method
    
    private func hierarchy() {
        addSubviews(label, circle)
    }
    
    
    private func layout() {
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.verticalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        circle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalTo(label.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(6)
        }
    }
    
    func updateTextColor(to color: UIColor) {
        label.textColor = color
    }
    
    
    
}

