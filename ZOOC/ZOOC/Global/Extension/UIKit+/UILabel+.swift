//
//  UILabel+.swift
//  ZOOC
//
//  Created by 류희재 on 2023/01/09.
//

import UIKit

extension UILabel {
    func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attributedString
    }
    
    func asUnderLine(_ targetString: String?) {
        guard let targetString else { return }
        let attributedString = NSAttributedString(string: targetString,
                                                  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])

        attributedText = attributedString
    }
    
    func setLineSpacing(spacing: CGFloat, alignment: NSTextAlignment = .left) {
        guard let text = text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = alignment
        style.lineBreakStrategy = .hangulWordPriority
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
    
    func setAttributeLabel(targetString: [String], color: UIColor?, font: UIFont?, spacing: CGFloat = 0, baseLineOffset: CGFloat = 0, alignment: NSTextAlignment = .left) {
        let fullText = text ?? ""
        let style = NSMutableParagraphStyle()
        let attributedString = NSMutableAttributedString(string: fullText)
        
        for target in targetString {
            let range = (fullText as NSString).range(of: target)
            attributedString.addAttributes(
                [.font: font as Any,
                 .foregroundColor: color as Any,
                 .baselineOffset: baseLineOffset], // Add baseline offset here
                range: range
            )
        }
        
        style.lineSpacing = spacing
        style.alignment = alignment
        attributedString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }

}


