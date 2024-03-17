//
//  CustomView.swift
//  ZOOC
//
//  Created by 류희재 on 12/12/23.
//

import UIKit

import SnapKit
import Then

final class CustomView: UIView {
    
    // MARK: - Properties
    
    let customTopView = CustomTopView()
    let conceptView = ConceptView()
    let albumView = AlbumView()
    
    let customAIButton = UIButton()
    private let plusIcon = UIImageView(image: .zwImage(.ic_plus_mini).withTintColor(.zw_black))
    let buttonTitleLabel = PetNameLabel()
    var gradientLayer: CAGradientLayer?
    
    // MARK: - UI Components
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = customAIButton.bounds
        gradientLayer.cornerRadius = 20
        gradientLayer.masksToBounds = false
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor(r: 255, g: 143, b: 183),
            UIColor(r: 108, g: 220, b: 214),
            UIColor(r: 37, g: 127, b: 232)
        ].map(\.cgColor)

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 3
        shapeLayer.path = UIBezierPath(
          roundedRect: customAIButton.bounds.insetBy(
            dx: 1.5,
            dy: 1.5
          ),
          cornerRadius: 20
        ).cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor

        gradientLayer.mask = shapeLayer
        
        if let oldLayer = self.gradientLayer {
            customAIButton.layer.replaceSublayer(oldLayer, with: gradientLayer)
        } else {
            customAIButton.layer.addSublayer(gradientLayer)
        }
        
        self.gradientLayer = gradientLayer
        
        
    }
    
    // MARK: - Custom Method
    
    private func style() {
        customAIButton.do {
            $0.backgroundColor = .zw_white
            $0.makeCornerRound(radius: 20)
        }
        
        buttonTitleLabel.do {
            $0.font = .zw_Subhead4
            $0.textColor = .zw_black
        }
    }
    
    private func hieararchy() {
        self.addSubviews(
            customTopView,
            conceptView,
            albumView,
            customAIButton
        )
        
        customAIButton.addSubviews(
            plusIcon,
            buttonTitleLabel
        )
    }
    
    private func layout() {
        customTopView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        conceptView.snp.makeConstraints {
            $0.top.equalTo(customTopView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(customAIButton.snp.top).inset(30)
        }
        
        albumView.snp.makeConstraints {
            $0.edges.equalTo(conceptView)
        }
        
        customAIButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(130)
            $0.height.equalTo(40)
        }
        
        plusIcon.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        buttonTitleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(11.5)
            $0.leading.equalTo(plusIcon.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func updateUI(_ type: CustomViewType) {
        buttonTitleLabel.text = type.buttonTitle
        switch type {
        case .concept:
            conceptView.isHidden = false
            albumView.isHidden = true
            customTopView.conceptButton.isSelected = true
            customTopView.albumButton.isSelected = false
            customTopView.conceptButtonUnderline.isHidden = false
            customTopView.albumButtonUnderline.isHidden = true
        case .album:
            conceptView.isHidden = true
            albumView.isHidden = false
            customTopView.conceptButton.isSelected = false
            customTopView.albumButton.isSelected = true
            customTopView.conceptButtonUnderline.isHidden = true
            customTopView.albumButtonUnderline.isHidden = false
        }
    }
}

