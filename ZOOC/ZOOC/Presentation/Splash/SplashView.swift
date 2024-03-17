//
//  SplashView.swift
//  ZOOC
//
//  Created by 류희재 on 1/15/24.
//

import UIKit

import SnapKit
import Then

final class SplashView: UIView {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView(image: UIImage(named: "fitapat"))
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hieararchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func style() {
        self.backgroundColor = .zw_background
        imageView.contentMode = .scaleAspectFit
    }
    
    private func hieararchy() {
        self.addSubview(imageView)
    }
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(160)
        }
    }
}






