//
//  UploadingToast.swift
//  ZOOC
//
//  Created by 장석우 on 11/26/23.
//

import UIKit

import SnapKit



final class UploadingToast: UIView {
    
    enum State: Equatable {
        case willStart
        case uploading
        case modeling
        case done
        case fail
        
        var title: String {
            switch self {
            case .willStart: return String(localized: "이미지를 업로드 하고 있어요")
            case .uploading: return String(localized: "이미지를 업로드 하고 있어요")
            case .modeling: return String(localized: "반려동물의 AI 모델을 생성하고 있어요")
            case .done: return String(localized: "반려동물 등록에 성공했어요")
            case .fail: return String(localized: "이미지 업로드에 실패했어요")
            }
        }
        
        var description: String? {
            switch self {
            case .willStart: return String(localized: "이미지 업로드 도중 화면을 닫거나, 앱을 중단하면 업로드가 중단될 수 있어요")
            case .uploading: return String(localized: "이미지 업로드 도중 화면을 닫거나, 앱을 중단하면 업로드가 중단될 수 있어요")
            case .modeling: return nil
            case .done: return String(localized: "반려동물 커스텀 굿즈를 지금 만들어보세요")
            case .fail: return String(localized: "인터넷 연결 상태를 확인 후 다시 시도해주세요")
            }
        }
    }
    
    //MARK: - UI Components
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zw_Subhead3
        label.textColor = .zw_black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .zw_Body2
        label.textColor = .zw_gray
        label.numberOfLines = 2
        return label
    }()
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .price_small
        label.textColor = .zw_lightgray
        label.textAlignment = .right
        return label
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .zw_brightgray
        view.progressTintColor = .zw_point
        view.progress = 0.0
        return view
    }()
    
    let xButton: UIButton = {
        let button = UIButton()
        button.setImage(.zwImage(.btn_x).withTintColor(.zw_lightgray), for: .normal)
        return button
    }()
    
    private let checkImageView = UIImageView(image: .zwImage(.ic_minicheck))

    
    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()
    
    //MARK: - Life Cycle
    
    
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
        
        self.layer.makeShadow(color: .black, alpha: 0.07, x: 0, y: 0, blur: 20, spread: 0)
        contentView.makeCornerRound(radius: 6)
        progressView.makeCornerRound(ratio: 2)
    }
    
    //MARK: - Custom Method
    
    private func style() {
        contentView.backgroundColor = .zw_white
        alpha = 0
    }
    
    private func hierarchy() {
        self.addSubview(contentView)
        
        contentView.addSubviews(vStackView, xButton)
        vStackView.addArrangedSubViews(hStackView, descriptionLabel, percentageLabel, progressView)
        hStackView.addArrangedSubViews(checkImageView, titleLabel)
        
    }
    
    private func layout() {
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(28)
        }
        
        xButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(36)
        }
        
        
        checkImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
        
        progressView.snp.makeConstraints {
            $0.height.equalTo(5)
        }
    }
}

extension UploadingToast {
    
    func updateUI(_ state: UploadingToast.State, progress: Float? = nil) {
        self.titleLabel.text = state.title
        self.descriptionLabel.text = state.description
        self.descriptionLabel.setLineSpacing(spacing: 5)
        
        self.percentageLabel.textColor = state != .fail ? .zw_lightgray : .zw_red
        self.progressView.progressTintColor = state != .fail ? .zw_point : .zw_red
        
        self.percentageLabel.isHidden = state == .done
        self.checkImageView.isHidden = state != .done
        self.progressView.isHidden = state == .done
        self.xButton.isHidden = state != .fail
        
        guard let progress else { return }
        self.percentageLabel.text = String(format: "%.0f", progress * 100) + "%"
        self.progressView.setProgress(progress, animated: state == .uploading)
    }
    
}
