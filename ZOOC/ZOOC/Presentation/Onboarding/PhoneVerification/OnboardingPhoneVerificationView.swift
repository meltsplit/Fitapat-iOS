//
//  OnboardingPhoneVerificationView.swift
//  ZOOC
//
//  Created by 장석우 on 3/5/24.
//

import UIKit

import SnapKit
import Then

final class OnboardingPhoneVerificationView: UIView {
    
    // MARK: - Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    let phoneTextField = FapTextField(placeholder: "010-0000-0000",
                                      limit: 13,
                                      keyboardType: .numberPad)
    
    let sendButton = UIButton()
    let codeTextField = FapTextField(placeholder: "인증번호를 입력해주세요",
                                      limit: 6,
                                      keyboardType: .numberPad)
    let failLabel = UILabel()
    
    let signUpButton = FapBottomButton(title: "회원가입")
    let timerLabel = UILabel()
    
    // MARK: - UI Components
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate()
        style()
        hierarchy()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Custom Method
    
    private func delegate() {
        phoneTextField.fapDelegate = self
        codeTextField.fapDelegate = self
    }
    
    private func style() {
        scrollView.showsVerticalScrollIndicator = false
        
        titleLabel.do {
            $0.font = .zw_Subhead1
            $0.text = "전화번호를 입력해주세요"
            $0.textAlignment = .left
            $0.textColor = .zw_black
        }
        
        descriptionLabel.do {
            $0.font = .zw_Body1
            $0.text = "시안 전송과 배송현황 안내를 위해 필요해요"
            $0.textColor = .zw_gray
            $0.textAlignment = .left
        }
        
        phoneTextField.do {
            $0.highlightWhenExceedLimit = false
        }
    
        
        sendButton.do {
            $0.setTitle("인증 요청", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Subhead4
            $0.isEnabled = false
            $0.setBackgroundColor(.zw_lightgray, for: .disabled)
            $0.setBackgroundColor(.zw_black, for: .normal)
            $0.makeCornerRound(radius: 2)
        }
        
        codeTextField.do {
            $0.highlightWhenExceedLimit = false
            $0.isHidden = true
        }

        timerLabel.do {
            $0.font = .zw_Body1
            $0.textColor = .zw_black
        }
        
        failLabel.do {
            $0.font = .zw_caption2
            $0.textColor = .zw_red
        }
        
        signUpButton.isEnabled = false
        
    }
    
    private func hierarchy() {
        
        self.addSubviews(scrollView, signUpButton)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            titleLabel,
            descriptionLabel,
            phoneTextField,
            sendButton,
            codeTextField,
            failLabel
        )
        
        codeTextField.addSubview(timerLabel)
    }
    
    private func layout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(signUpButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.leading.equalToSuperview().offset(28)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(28)
        }
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(28)
            $0.height.equalTo(50)
        }
      
        
        sendButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(phoneTextField)
            $0.width.equalTo(109)
            $0.leading.equalTo(phoneTextField.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        codeTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.bottom.lessThanOrEqualToSuperview().inset(40)
            $0.height.equalTo(50)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        failLabel.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(8)
            $0.leading.equalTo(codeTextField)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
    
    
    func updateTimerLabel(_ timeLeft: Int) {
        let minutes = timeLeft / 60
        let seconds = String(format: "%02d", timeLeft % 60)
        timerLabel.text = "\(minutes):\(seconds)"
    }
    
    func resetUI() {
        sendButton.setTitle("재전송", for: .normal)
        
        codeTextField.text = ""
        codeTextField.isHidden = false
        codeTextField.setBorder(width: 1, color: .zw_brightgray)
        codeTextField.becomeFirstResponder()
        
        signUpButton.isEnabled = false
        failLabel.isHidden = true
        timerLabel.textColor = .zw_black
        
    }

}

extension OnboardingPhoneVerificationView: FapTextFieldDelegate {
    
    func fapTextField(_ textField: FapTextField, 
                      shouldChangeCharactersIn range: NSRange,
                      replacementString string: String) -> Bool {
        if textField == phoneTextField {
            if range.location == 13 {
                return false
            }
            
            // Auto-add hyphen before appending 4rd or 7th digit
            if range.length == 0 && (range.location == 3 || range.location == 8) {
                textField.text = "\(textField.text!)-\(string)"
                return false
            }
            
            return true
        }
        return true
    }
  
}
