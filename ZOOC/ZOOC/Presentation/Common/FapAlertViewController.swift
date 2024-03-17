//
//  FapAlertViewController.swift
//  ZOOC
//
//  Created by 장석우 on 11/16/23.
//

import UIKit

enum LeftRight {
    case left
    case right
}

enum FapAlertType {
    case notEnoughImage
    case leaveRegisterPage
    case failUploadGenAiImage
    case deleteAccount
    case leaveAIPage
    case leaveCustomPage
    case deleteProduct
 
    
    var title: String {
        switch self {
        case .leaveRegisterPage:
            return "등록을 그만두시나요?"
        case .notEnoughImage:
            return "생성에 필요한 사진이 부족해요"
        case .failUploadGenAiImage:
            return "반려동물 사진을 다시 업로드해주세요"
        case .deleteAccount:
            return "회원 탈퇴 하시겠습니까?"
        case .leaveAIPage:
            return "이제 마지막 단계에요!"
        case .deleteProduct:
            return "선택한 상품을 삭제하시나요?"
        case .leaveCustomPage:
            return String(localized: "커스텀을 그만두시나요?")
        }
    }
    
    var description: String {
        switch self {
        case .leaveRegisterPage:
            return "지금 떠나면 지난 과정이 저장되지 않아요"
        case .notEnoughImage:
            return "8장 이상 15장 미만의 사진을 선택해주세요"
        case .failUploadGenAiImage:
            return "이미지 업로드 도중 화면을 닫거나, 앱을\n중단하면 업로드가 중단될 수 있어요"
        case .deleteAccount:
            return "회원 탈퇴 시 모든 정보와 내역이 삭제됩니다"
        case .leaveAIPage:
            return "지금 떠나면 내용이 저장되지 않아요"
        case.deleteProduct:
            return "장바구니에서 상품이 제외돼요"
        case .leaveCustomPage:
            return String(localized: "지금 떠나면 최종 결과물을 볼 수 없어요")
        }
    }
    
    var left: String {
        switch self {
        case .leaveRegisterPage:
            return "그만두기"
        case .notEnoughImage:
            return "취소"
        case .failUploadGenAiImage:
            return "나중에"
        case .leaveAIPage:
            return  "나가기"
        case .deleteProduct:
            return "삭제하기"
        case .deleteAccount:
            return "탈퇴하기"
        case .leaveCustomPage:
            return String(localized: "그만두기")
        }
    }
    
    var right: String {
        switch self {
        case .leaveRegisterPage:
            return "취소"
        case .notEnoughImage:
            return "다시 고르기"
        case .failUploadGenAiImage:
            return "재시도"
        case .deleteAccount:
            return "취소"
        case .leaveAIPage:
            return "이어 하기"
        case .deleteProduct:
            return "취소"
        case .leaveCustomPage:
            return String(localized: "취소")
        }
    }
    
    var tintAt: LeftRight {
        switch self {
        case .notEnoughImage,
                .failUploadGenAiImage:
            return .right
        
        default:
            return .left
        }
    }
}

protocol FapAlertViewControllerDelegate: AnyObject {
    func leftButtonDidTap(_ alertType: FapAlertType)
    func rightButtonDidTap(_ alertType: FapAlertType)
}

final class FapAlertViewController: UIViewController {
    
    //MARK: - Properties
    
    private var alertType: FapAlertType {
        didSet{
            updateUI(alertType)
        }
    }
    
    weak var delegate: FapAlertViewControllerDelegate?
    
    //MARK: - UI Components
    
    private let alertView = UIView()
    private let dimmedView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private lazy var leftButton = UIButton()
    private lazy var rightButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(_ alertType: FapAlertType) {
        self.alertType = alertType
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
        
        style()
        hierarchy()
        layout()
        
        updateUI(alertType)
    }

    
    //MARK: - Custom Method
    
    private func target() {
        leftButton.addTarget(self, action: #selector(leftButtonDidTap), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        view.backgroundColor = .clear
        
        
        alertView.do {
            $0.backgroundColor = .zw_background
            $0.layer.cornerRadius = 2
            $0.clipsToBounds = true
            $0.alpha = 1
        }
        
        dimmedView.do {
            $0.backgroundColor = .black
            $0.alpha = 0.4
        }
        
        titleLabel.do {
            $0.font = .zw_Subhead1
            $0.textColor = .zw_black
        }
        
        descriptionLabel.do {
            $0.font = .zw_Body2
            $0.textColor = .zw_gray
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        leftButton.do {
            $0.backgroundColor = alertType.tintAt == .left ? .zw_black : .zw_lightgray
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zw_Subhead3
        }
        
        rightButton.do {
            $0.backgroundColor = alertType.tintAt == .right ? .zw_black : .zw_lightgray
            $0.setTitleColor(.zw_white, for: .normal)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = .zw_Subhead3
        }
    }
    
    private func hierarchy() {
        view.addSubviews(dimmedView,alertView)
        alertView.addSubviews(titleLabel, descriptionLabel, leftButton, rightButton)
    }
    
    private func layout() {
        alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(319)
        }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        let recommedWidth = 140
        let defaultWidth = 113
        
        let leftButtonWidth = (alertType.tintAt == .left) ? recommedWidth : defaultWidth
        let rightButtonWidth = (alertType.tintAt == .right) ? recommedWidth : defaultWidth
        
        leftButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.bottom.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().offset(28)
            $0.width.equalTo(leftButtonWidth)
            $0.height.equalTo(51)
        }
        
        rightButton.snp.makeConstraints {
            $0.top.equalTo(leftButton)
            $0.bottom.equalTo(leftButton)
            $0.trailing.equalToSuperview().inset(28)
            $0.width.equalTo(rightButtonWidth)
            $0.height.equalTo(leftButton)
        }
    }
    
    private func updateUI(_ alertType: FapAlertType) {
        titleLabel.text = alertType.title
        descriptionLabel.text = alertType.description
        leftButton.setTitle(alertType.left, for: .normal)
        rightButton.setTitle(alertType.right, for: .normal)
        descriptionLabel.setLineSpacing(spacing: 3, alignment: .center)
        
        view.layoutIfNeeded()
    }
    

    
    //MARK: - Action Method
    
    @objc func leftButtonDidTap() {
        dismiss(animated: false)
        delegate?.leftButtonDidTap(self.alertType)
    }
    
    @objc func rightButtonDidTap() {
        dismiss(animated: false)
        delegate?.rightButtonDidTap(self.alertType)
    }
}
