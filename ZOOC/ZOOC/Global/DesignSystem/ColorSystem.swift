//
//  UIColor+.swift
//  ZOOC
//
//  Created by 장석우 on 11/6/23.
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r)/255,green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}


extension UIColor {
    
    static var zw_tabbar_backgound: UIColor {
        return UIColor(r: 247, g: 247, b: 249)
    }
    
    static var zw_background: UIColor {
        return UIColor(r: 245, g: 245, b: 247)
    }
    
    static var zw_white: UIColor {
        return UIColor(r: 255, g: 255, b: 255)
    }
    
    static var zw_brightgray: UIColor {
        return UIColor(r: 230, g: 230, b: 230)
    }
    
    static var zw_lightgray: UIColor {
        return UIColor(r: 191, g: 191, b: 191)
    }
    
    static var zw_gray: UIColor {
        return UIColor(r: 130, g: 130, b: 130)
    }
    
    static var zw_darkgray: UIColor {
        return UIColor(r: 96, g: 96, b: 96)
    }
    
    static var zw_black: UIColor {
        return UIColor(r: 38, g: 38, b: 38)
    }
    
    static var zw_point: UIColor {
        return UIColor(r: 79, g: 86, b: 255)
    }
    
    
    static var zw_red: UIColor {
        return UIColor(r: 255, g: 69, b: 58)
    }
}
