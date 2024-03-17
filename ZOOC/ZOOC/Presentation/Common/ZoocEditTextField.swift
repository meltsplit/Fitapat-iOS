//
//  MyEditTextField.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/08.
//

import UIKit
enum TextFieldType {
    case profile
    case breed
    
    var limit: Int {
        switch self {
        case .profile: return 4
        case .breed: return 20
        }
    }
}

enum TextFieldState {
    case empty
    case editing
    case exceed
    
    var currentTextColor: UIColor {
        switch self{
        case .empty:
            return .zw_lightgray
        case .editing:
            return .zw_point
        case .exceed:
            return .zw_point
        }
    }
    
    var limitTextColor: UIColor {
        switch self{
        case .empty:
            return .zw_lightgray
        case .editing:
            return .zw_lightgray
        case .exceed:
            return .zw_point
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .empty:
            return .zw_brightgray
        case .editing:
            return .zw_point
        case .exceed:
            return .zw_point
        }
    }
}

@objc protocol ZoocEditTextFieldDelegate: AnyObject {
    @objc optional func zoocTextFieldDidReturn(_ textField: ZoocEditTextField)
}

final class ZoocEditTextField: UITextField {
    
    
    var textFieldType: TextFieldType
    var textFieldState: TextFieldState
    
    let characterCountLabel = UILabel()
    let buttonView = UIButton()
    let currentTextCnt = 0
    
    weak var zoocDelegate: ZoocEditTextFieldDelegate?
    
    init(textFieldType: TextFieldType, textFieldState: TextFieldState = .empty) {
        self.textFieldType = textFieldType
        self.textFieldState = textFieldState
        super.init(frame: .zero)
        
        setStyle()
        setRightView()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 20
        
        return padding
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)

        /// 모든 방향에 20만큼 터치 영역 증가
        /// dx: x축이 dx만큼 증가 (음수여야 증가)
        let touchArea = bounds.insetBy(dx: -20, dy: -30)
        return touchArea.contains(point)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 20))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 20))
    }

    
    private func setStyle() {
        self.do {
            $0.returnKeyType = .done
            $0.addLeftPadding(inset: 20)
            $0.font = .zw_Body1
            $0.textColor = .zw_black
            $0.setBorder(width: 1, color: .zw_brightgray)
        }
    }
    private func setRightView() {
        characterCountLabel.do {
            $0.text = "\(self.currentTextCnt)/\(self.textFieldType.limit)"
            $0.textColor = .zw_lightgray
            $0.textAlignment = .center
            $0.font = .price_small
        }
        
        self.rightView = characterCountLabel
        self.rightViewMode = .always
        self.delegate = self
    }
}

extension ZoocEditTextField {
    
    func updateTextField(_ currentText: String?) {
        guard let currentText else { return }
        let limit = self.textFieldType.limit
        
        switch currentText.count {
        case 0:
            self.textFieldState = .empty
            self.characterCountLabel.text = "\(currentText.count)/\(limit)"
        case textFieldType.limit...:
            self.textFieldState = .exceed
            let fixedText = self.text?.substring(
                from: 0,
                to: self.textFieldType.limit-1
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.text = fixedText
                self.characterCountLabel.text = "\(limit)/\(limit)"
            }
        default:
            self.textFieldState = .editing
            self.characterCountLabel.text = "\(currentText.count)/\(limit)"
        }
        
        if isEditing {
            self.characterCountLabel.textColor = textFieldState.limitTextColor
            self.characterCountLabel.asColor(targetString: "\(currentText.count)", color: textFieldState.currentTextColor)
        } else {
            self.characterCountLabel.textColor = .zw_lightgray
        }
        
     
    }
}

extension ZoocEditTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor.zw_point.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        zoocDelegate?.zoocTextFieldDidReturn?(self)
        endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = UIColor.zw_brightgray.cgColor
        self.characterCountLabel.textColor = .zw_lightgray
    }
    
    
}

