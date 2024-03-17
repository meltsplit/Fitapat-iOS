//
//  CustomSwitch.swift
//  ZOOC
//
//  Created by 류희재 on 1/31/24.
//

import UIKit

import SnapKit
import Then

final class CustomSwitch: UIView {
    
    //MARK: - Properties
    
    var isOn: Bool = true {
        didSet {
            updateUI()
        }
    }

    // MARK: - UI Components

    private let switchbutton = UIView()
    private let onLabel = UILabel()
    private let offLabel = UILabel()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        style()
        hieararchy()
        layout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switchbutton.makeCornerRound(ratio: 2)
    }

    // MARK: - Custom Method

    private func style() {
        self.do {
            $0.makeCornerRound(radius: 13)
            $0.setBorder(width: 1, color: .zw_white)
            $0.backgroundColor = .zw_white.withAlphaComponent(0.15)
        }

        switchbutton.do {
            $0.backgroundColor = .zw_white
        }

        onLabel.do {
            $0.text = "ON"
            $0.font = .zw_Body3
            $0.textColor = .zw_white
        }

        offLabel.do {
            $0.text = "OFF"
            $0.font = .zw_Body3
            $0.textColor = .zw_white
            $0.isHidden = true
        }
    }

    private func hieararchy() {
        self.addSubviews(
            switchbutton,
            onLabel,
            offLabel
        )
    }

    private func layout() {
        self.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(26)
        }
        
        switchbutton.snp.makeConstraints {
            $0.verticalEdges.trailing.equalToSuperview().inset(4)
            $0.size.equalTo(18)
        }
        
        onLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.leading.equalToSuperview().offset(9)
        }
        
        offLabel.snp.makeConstraints {
            $0.verticalEdges.trailing.equalToSuperview().inset(6)
        }
    }
}

extension CustomSwitch {
    func updateUI() {
        Haptic.impact(.light).run()
        if isOn {
            self.backgroundColor = .zw_white.withAlphaComponent(0.15)
            onLabel.isHidden = false
            offLabel.isHidden = true
            switchbutton.snp.remakeConstraints {
                $0.verticalEdges.trailing.equalToSuperview().inset(4)
                $0.size.equalTo(18)
            }
        } else {
            self.backgroundColor = .zw_gray
            onLabel.isHidden = true
            offLabel.isHidden = false
            switchbutton.snp.remakeConstraints {
                $0.verticalEdges.leading.equalToSuperview().inset(4)
                $0.size.equalTo(18)
            }
        }
    }
}
