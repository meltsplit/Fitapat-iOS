//
//  ZoocTextField.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/24.
//

import UIKit

import SnapKit
import Then

@objc protocol FapTextFieldDelegate: UITextFieldDelegate {
    @objc optional func fapTextFieldDidReturn(_ textField: FapTextField)
    @objc optional func fapTextFieldDidEndEditing(_ textField: FapTextField)
    @objc optional func fapTextField(_ textField: FapTextField, 
                                      shouldChangeCharactersIn range: NSRange,
                                      replacementString string: String) -> Bool
}

final class FapTextField: UITextField {
    
    //MARK: - Properties
    
    weak var fapDelegate: FapTextFieldDelegate?
    private let limit: Int?
    var highlightWhenExceedLimit: Bool = true
    
    //MARK: - UI Components
    
    //MARK: - Life Cycle
    
    init(placeholder: String, 
         limit: Int?,
         keyboardType: UIKeyboardType = .default) {
        
        self.limit = limit
        
        super.init(frame: .zero)
        
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        
        delegate()
        style()
        updateEditingUI()
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 20
        
        return padding
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

    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Method
    
    private func delegate() {
        delegate = self
    }
    
    private func style() {
        self.font = .zw_Subhead4
        self.textColor = .zw_black
        self.setPlaceholderColor(color: .zw_lightgray)
        
        self.autocapitalizationType = .none
        self.returnKeyType = .done
        self.backgroundColor = .zw_background
        self.addLeftPadding(inset: 18)
        self.makeCornerRound(radius: 2)
        
    }
    
    private func updateEditingUI() {
        let borderColor: UIColor = isEditing ? .zw_point : .zw_brightgray
        setBorder(width: 1, color: borderColor)
    }
    
    //MARK: - Public Method
    
    func updateInvalidUI() {
        guard let text else { return }
        let borderColor: UIColor = text.hasText ? .zw_brightgray : .zw_red
        setBorder(width: 1, color: borderColor)
    }
    
    
    //MARK: - Action Method
}

//MARK: - UITextFieldDelegate

extension FapTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateEditingUI()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fapDelegate?.fapTextFieldDidReturn?(self)
        endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateEditingUI()
        fapDelegate?.fapTextFieldDidEndEditing?(self)
    }
    
    
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let bool = fapDelegate?.fapTextField?(self,
                                              shouldChangeCharactersIn: range,
                                              replacementString: string)
        
        guard self.keyboardType != .numberPad else { return bool ?? true }
        guard let limit else { return true }
        
        let oldText = textField.text ?? "" // 입력하기 전 textField에 표시되어있던 text 입니다.
        let addedText = string // 입력한 text 입니다.
        let newText = oldText + addedText // 입력하기 전 text와 입력한 후 text를 합칩니다.
        let newTextLength = newText.count // 합쳐진 text의 길이 입니다.
        
        // 글자수 제한
        if newTextLength <= limit { return true }
        
        let lastWordOfOldText = String(oldText[oldText.index(before: oldText.endIndex)]) // 입력하기 전 text의 마지막 글자 입니다.
        let separatedCharacters = lastWordOfOldText.decomposedStringWithCanonicalMapping.unicodeScalars.map{ String($0) } // 입력하기 전 text의 마지막 글자를 자음과 모음으로 분리해줍니다.
        let separatedCharactersCount = separatedCharacters.count // 분리된 자음, 모음의 개수입니다.
        

        
        if separatedCharactersCount == 1 && !addedText.isConsonant { // -- A
            return true
        }
        
        if separatedCharactersCount == 2 && addedText.isConsonant { // -- B
            return true
        }
        
        if separatedCharactersCount == 3 && addedText.isConsonant { // -- C
            return true
        }
        
        
        
        return bool ?? true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let limit else { return }
        var text = textField.text ?? "" // textField에 수정이 반영된 후의 text 입니다.
        let highLightColor = highlightWhenExceedLimit ? UIColor.zw_red : UIColor.zw_point
        layer.borderColor = text.count >= limit ? highLightColor.cgColor : UIColor.zw_point.cgColor
        if text.count > limit {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: limit - 1)
            let fixedText = String(text[startIndex...endIndex])
            textField.text = fixedText
        }
    }
    
}




