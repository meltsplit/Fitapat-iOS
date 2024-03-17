//
//  ExhuastedTicketAlertViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2/4/24.
//

import UIKit

import RxGesture
import RxSwift

import SnapKit
import Then

protocol ExhuastedTicketAlertViewDelegate: AnyObject {
    func exhuastedTicketConfirmButtonDidTap()
}

final class ExhuastedTicketAlertViewController: UIViewController {
    
    private unowned var delegate: ExhuastedTicketAlertViewDelegate
    
    private let disposeBag = DisposeBag()
    
    private let dimmedView = UIView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let confirmButton = PetNameButton()
    
    init(delegate: ExhuastedTicketAlertViewDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        
        style()
        hierarchy()
        layout()
        
        bind()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        view.do {
            $0.backgroundColor = .clear
        }
        
        dimmedView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.45)
        }
        
        contentView.do {
            $0.backgroundColor = .zw_background
            $0.makeCornerRound(radius: 2)
        }
        
        titleLabel.do {
            $0.text = "가진 티켓을 모두 소진했어요!"
            $0.font = .zw_Subhead1
            $0.textColor = .zw_black
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.text = "내가 만든 AI 캐릭터 중 선택해 커스텀 제품을\n구매하면 5장을 무료로 또 드릴게요!"
            $0.font = .zw_Body2
            $0.textColor = .zw_gray
            $0.numberOfLines = 2
            $0.setAttributeLabel(targetString: ["5장을 무료로"],
                                 color: .zw_point,
                                 font: .zw_Body2,
                                 alignment: .center)
        }
        
        imageView.do {
            $0.image = .graphicsGift
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        
        confirmButton.do {
            $0.backgroundColor = .zw_black
            $0.setTitle("{pet} 커스텀 제품 구매하기", for: .normal)
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.font = .zw_Subhead3
            $0.makeCornerRound(radius: 2)
        }
    }
    
    private func hierarchy() {
        view.addSubviews(dimmedView,contentView)
        
        contentView.addSubviews(
            titleLabel,
            descriptionLabel,
            imageView,
            confirmButton
        )
    }
    
    private func layout() {
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(36)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(127.adjusted)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(28)
        }
    }
    
    private func bind() {
        dimmedView.rx.tapGesture().when(.recognized)
            .subscribe(with: self, onNext: { owner, _ in
                owner.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .do(onNext: { [weak self] in self?.dismiss(animated: false)})
            .bind(onNext: delegate.exhuastedTicketConfirmButtonDidTap)
            .disposed(by: disposeBag)
    }
}
