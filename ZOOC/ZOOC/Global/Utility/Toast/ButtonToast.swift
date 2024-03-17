//
//  ButtonToast.swift
//  ZOOC
//
//  Created by 장석우 on 11/26/23.
//

import UIKit

import SnapKit

protocol ButtonToastDelegate: AnyObject {
    func goButtonDidTap(_ toast: ButtonToast)
}

final class ButtonToast: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ButtonToastDelegate?
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel() 
        label.textColor = .zw_white
        label.font = .zw_Subhead4
        label.textAlignment = .left
        return label
    }()
    
    lazy var goButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.zw_point, for: .normal)
        button.titleLabel?.font = .pretendard(font: .semiBold, size: 14)
        button.addTarget(self,
                         action: #selector(goButtonDidTap),
                         for: .touchUpInside)
        return button
    }()

    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    
    init(_ message: String, with buttonMessage: String) {
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
        updateUI(message, with: buttonMessage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeCornerRound(radius: 2)
        
    }
    
    private func style() {
        backgroundColor = .zw_black
    }
    
    private func hierarchy() {
        self.addSubviews(hStackView)
        
        hStackView.addArrangedSubViews(titleLabel, goButton)
    }
    
    private func layout() {
        
        hStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(14)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
        
        goButton.setContentHuggingPriority(.required, for: .horizontal)
        goButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func updateUI(_ message: String, with buttonMessage: String) {
        titleLabel.text = message
        goButton.setTitle(buttonMessage, for: .normal)
    }
    
    @objc
    private func goButtonDidTap() {
        delegate?.goButtonDidTap(self)
        self.removeFromSuperview()
    }
    
}
