//
//  TicketView.swift
//  ZOOC
//
//  Created by 장석우 on 2/3/24.
//

import UIKit

import SnapKit
import Then

final class TicketView: UIView {
    
    private let amountLabel = UILabel()
    private let ticketImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBorder(width: 1, color: .zw_darkgray)
        makeCornerRound(ratio: 2)
    }
    
    private func style() {
        
        self.backgroundColor = .zw_background
        
        amountLabel.do {
            $0.font = .price_small
            $0.textColor = .zw_darkgray
        }
        
        ticketImageView.do {
            $0.image = .icTicket
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
    }
    
    private func hierarchy() {
        addSubviews(amountLabel,
                    ticketImageView
        )
    }
    
    private func layout() {
        amountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        ticketImageView.snp.makeConstraints {
            $0.leading.equalTo(amountLabel.snp.trailing).offset(6)
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(20)
        }
    }
    
    func updateUI(_ amount: Int) {
        amountLabel.text = String(amount)
    }
}
