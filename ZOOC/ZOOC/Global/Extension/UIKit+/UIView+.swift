//
//  UIView+.swift
//  ZOOC
//
//  Created by 장석우 on 2022/12/21.
//

import UIKit

extension UIView {
    
    func addSubviews (_ views: UIView...){
        views.forEach { self.addSubview($0) }
    }
    
    func makeShadow (
        color: UIColor,
        offset : CGSize,
        radius : CGFloat,
        opacity : Float)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func makeCornerRound (radius: CGFloat){
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func makeCornerRound (ratio : CGFloat) {
        layer.cornerRadius = self.frame.height / ratio
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func showToast(_ message: String,
                   view: UIView? = UIApplication.shared.firstWindow,
                   bottomInset: CGFloat = 86
    ) {
        guard let view else { return }
        Toast().show(message: message,
                     view: view,
                     bottomInset: bottomInset
        )
    }
    
    func showToastAtTop(_ message: String,
                        view: UIView? = UIApplication.shared.firstWindow,
                        topInset: CGFloat = 76) {
        guard let view else { return }
        Toast().show(message: message,
                     view: view,
                     topInset: topInset)
    }
    
    func addInnerShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        layer.masksToBounds = true
        
        // Create the shadow layer
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOpacity = alpha
        shadowLayer.shadowOffset = CGSize(width: x, height: y)
        shadowLayer.shadowRadius = blur / UIScreen.main.scale
        
        // Create the shadow path
        if spread == 0 {
            shadowLayer.shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowLayer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
        // Add the shadow layer to the view's layer
        layer.addSublayer(shadowLayer)
    }
    
    func setGradientBorder(
            borderWidth: CGFloat,
            cornerRadius: CGFloat,
            colors: [UIColor],
            startPoint: CGPoint,
            endPoint: CGPoint
        ) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            gradientLayer.masksToBounds = false
            gradientLayer.locations = [0, 0.5, 1]
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.colors = colors.map(\.cgColor)

            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = borderWidth
            shapeLayer.path = UIBezierPath(
              roundedRect: self.bounds.insetBy(
                dx: borderWidth-1.5,
                dy: borderWidth-1.5
              ),
              cornerRadius: cornerRadius
            ).cgPath
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor

            gradientLayer.mask = shapeLayer
            self.layer.addSublayer(gradientLayer)

        }
    
}

