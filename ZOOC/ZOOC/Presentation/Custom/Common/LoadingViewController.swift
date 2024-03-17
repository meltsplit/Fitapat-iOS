//
//  LoadingViewController.swift
//  ZOOC
//
//  Created by 장석우 on 12/27/23.
//

import UIKit

import SnapKit
import Then
import Lottie

import RxSwift
import RxCocoa

protocol LoadingViewControllerDelegate : AnyObject {
    func xButtonDidTap()
}

final class LoadingViewController : UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: LoadingViewControllerDelegate?
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let navigationTitleLabel = UILabel()
    private let xButton = UIButton()
    private let welshoAnimationView = LottieAnimationView(name: "welshi")
    
    private let titleLabel = PetNameLabel()
    private let descriptionLabel = UILabel()
    
    private let tipContainerView = UIView()
    private let tipLabel = UILabel()
    private let petEvolutionImageView = UIImageView()
    private let tipDescriptionLabel = PetNameLabel()
    
    //MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        hierarchy()
        layout()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        welshoAnimationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        welshoAnimationView.stop()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tipContainerView.makeCornerRound(radius: 10)
        
        tipLabel.makeCornerRound(radius: 12)
    }
    
    
    

    //MARK: - Custom Method
    
    private func style() {
        
        view.do {
            $0.backgroundColor = .zw_background
        }
        
        navigationTitleLabel.do {
            $0.text = "커스텀 AI 생성"
            $0.font = .zw_Subhead2
            $0.textColor = .zw_black
        }
        
        xButton.do {
            $0.setImage(.icExit, for: .normal)
        }
        
        
        welshoAnimationView.do {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
            $0.animationSpeed = 0.5
            
        }
        
        titleLabel.do {
            $0.font = .zw_Subhead3
            $0.textColor = .zw_black
            $0.text = "가상모델인 웰시코기가\n{pet}보다 먼저 변신하고 있어요!"
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.font = .zw_Body2
            $0.textColor = .zw_gray
            $0.text = "화면을 종료하지 말고 잠시 기다려주세요"
            $0.textAlignment = .center
        }
        
        tipContainerView.do {
            $0.backgroundColor = .zw_white
            $0.setBorder(width: 1, color: .init(r: 232, g: 232, b: 232))
        }
        
        tipLabel.do {
            $0.text = "    TIP    "
            $0.font = .zw_Body3
            $0.textColor = .zw_lightgray
            $0.setBorder(width: 1, color: .zw_lightgray)
        }
        
        petEvolutionImageView.do {
            $0.image = .petLoading
            $0.contentMode = .scaleAspectFit
        }
        
        tipDescriptionLabel.do {
            $0.text = "가상모델 이미지가 마음에 드신다면 커스텀 제품 구매를\n통해 {pet}의 모습을 제품으로 확인할 수 있어요!"
            $0.textColor = .zw_gray
            $0.font = .pretendard(font: .regular, size: 12)
            $0.numberOfLines = 2
            $0.setPetNameLabelStyle(targetString: ["커스텀 제품 구매"],
                                 color: .zw_point,
                                 font: .pretendard(font: .regular, size: 12),
                                 alignment: .center)
        }
        
    }
    
    private func hierarchy() {
        view.addSubviews(
            navigationTitleLabel,
            xButton,
            welshoAnimationView,
            titleLabel,
            descriptionLabel,
            tipContainerView
                         )
        
        tipContainerView.addSubviews(
            tipLabel,
            petEvolutionImageView,
            tipDescriptionLabel
        )
    }
    
    private func layout() {
        
        navigationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        xButton.snp.makeConstraints {
            $0.centerY.equalTo(navigationTitleLabel)
            $0.trailing.equalToSuperview().inset(28)
            $0.size.equalTo(36)
        }

        welshoAnimationView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(207)
            $0.centerY.equalToSuperview().offset(-100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(welshoAnimationView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        tipContainerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-50)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
        
        tipLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(24)
            $0.centerX.equalToSuperview()
        }
        
        petEvolutionImageView.snp.makeConstraints {
            $0.top.equalTo(tipLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.height.equalTo(104.adjusted)
        }
        
        tipDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(petEvolutionImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(24)
        }
        
    
    }
    
    private func bindUI() {
        xButton.rx.tap
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    let alertVC = FapAlertViewController(.leaveCustomPage)
                    alertVC.delegate = owner
                    owner.present(alertVC, animated: false)
            })
            .disposed(by: disposeBag)
    }

    
}

extension LoadingViewController: FapAlertViewControllerDelegate {
    func leftButtonDidTap(_ alertType: FapAlertType) {
        dismiss(animated: false)
        delegate?.xButtonDidTap()
    }
    
    func rightButtonDidTap(_ alertType: FapAlertType) {
        return
    }
    
    
}
