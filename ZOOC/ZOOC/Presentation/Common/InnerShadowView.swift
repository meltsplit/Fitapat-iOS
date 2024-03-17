//
//  InnerShadowView.swift
//  ZOOC
//
//  Created by 장석우 on 12/29/23.
//

import UIKit

enum Edge {
    case top
    case bottom
    
    var startPoint: CGPoint {
        switch self {
        case .top:
            return CGPoint(x: 0.5, y: 0.0)
        case .bottom:
            return CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    var endPoint: CGPoint {
        switch self {
        case .top:
            return CGPoint(x: 0.5, y: 1.0)
        case .bottom:
            return CGPoint(x: 0.5, y: 0.0)
        }
    }
}

final class InnerShadowView: UIView {
    
    //MARK: - Properties
    
    private let shadowAlpha: CGFloat
    private let edgePoint: Edge
    private var gradientLayer: CAGradientLayer?
    
    //MARK: - Life Cycle
    
    init(alpha: CGFloat = 0.8, edgePoint: Edge = .top) {
        self.shadowAlpha = alpha
        self.edgePoint = edgePoint
        super.init(frame: .zero)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureLayers(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Custom Method

    private func configureLayers(_ rect: CGRect) {
        if gradientLayer == nil {
            let layer = CAGradientLayer()
            layer.frame = rect
            layer.masksToBounds = false
            layer.startPoint = edgePoint.startPoint
            layer.endPoint = edgePoint.endPoint
            layer.colors = [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(shadowAlpha).cgColor
            ]
            
            self.layer.insertSublayer(layer, at: 1)
//            self.alpha = shadowAlpha
            self.gradientLayer = layer
        }
      }
}
