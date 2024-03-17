
//
//  FapWebViewController.swift
//  ZOOC
//
//  Created by 장석우 on 1/9/24.
//

import UIKit
import WebKit

import RxSwift
import RxRelay

import SnapKit

//MARK: iOS -> Web 로 메시지 호출 시, JS에 사전에 정의된 함수명과 일치해야 합니다.
enum JavaScriptFuncName: String {
    case responseToken
    case responseCharacter
    case getRefreshAuth
    case refreshError
    case unknown
}

//MARK: Web -> iOS로 메시지 호출 시, Web은 ListenerName에 맞게 작성해야합니다
enum ListenerName: String, CaseIterable {
    case authEvent
    case refreshEvent // 토큰시간 5시간일때에는 사용하지 않음
    case tokenExpired
    case transitionEvent
    case backEvent
    case characterEvent
    case petEvent
    case unknown
}


final class FapWebViewController: BaseViewController {
    
    //MARK: - Dependency
    
    private let viewModel: FapWebViewModel
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let webToAppMessageEvent = PublishRelay<WebToAppMessage>()
    
    //MARK: - UI Components

    private let indicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: - Web
    
    private let contentController = WKUserContentController()
    private let configuration = WKWebViewConfiguration()
    private lazy var webView = WKWebView(frame: .zero, configuration: configuration)
    
    // MARK: - Lifecycle
    
    init(viewModel: FapWebViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        isNavigationBarHidden = true
        isPopGestureEnabled = true
        
        addListener() // lazy webView에 config가 copy되어 주입되기에 addListner가 가장먼저 호출되어야 함.
        addiOSFlag()
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        style()
        hierarchy()
        layout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func addListener() {
        ListenerName.allCases.forEach { contentController.add(self, name: $0.rawValue) }
        configuration.userContentController = contentController
    }
    
    private func addiOSFlag() {
        guard let userAgent = WKWebView().value(forKey: "userAgent") as? String
        else { return }
        
        webView.customUserAgent = userAgent + " inApp"
    }
    
    private func bind() {
        let input = FapWebViewModel.Input(
            viewDidLoadEvent: rx.viewDidLoad.asObservable(),
            getMessageFromWebEvent: webToAppMessageEvent.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.loadWebView
            .asDriver(onErrorJustReturn: String())
            .drive(with: self, onNext: { owner, url in
                guard let url = URL(string: url) else { return }
                let request = URLRequest(url: url)
                owner.webView.load(request)
            })
            .disposed(by: disposeBag)
        
        
        output.backAction
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, data in
                if owner.webView.canGoBack {
                    owner.webView.goBack()
                } else {
                    owner.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.pushWebVC
            .asDriver(onErrorJustReturn: String())
            .drive(with: self, onNext: { owner, url in
                let nextVC = DIContainer.shared.makeFapWebVC(url: url)
                nextVC.hidesBottomBarWhenPushed = self == owner.navigationController?.viewControllers.first
                owner.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.popVC
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, data in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.popToRootVC
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, data in
                owner.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.presentWebVC
            .asDriver(onErrorJustReturn: String())
            .drive(with: self, onNext: { owner, url in
                let nextVC = DIContainer.shared.makeFapWebVC(url: url)
                owner.present(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.dismissVC
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.switchTab
            .asDriver(onErrorJustReturn: 1)
            .drive(with: self, onNext: { owner, index in
                owner.tabBarController?.selectedIndex = index
                let naviVC = owner.tabBarController?.selectedViewController as? UINavigationController
                naviVC?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.sendEvaluateJS
            .asDriver(onErrorJustReturn: (.unknown, String()))
            .drive(with: self, onNext: { owner, data in
                let funcName = data.0
                let body = data.1
                Task {
                    let jsCode = "javascript:\(funcName)('\(body)');"
                    try await owner.webView.evaluateJavaScript(jsCode)
                }
                
            })
            .disposed(by: disposeBag)
        
        output.switchToLoginVC
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, data in
                print("로그인 세션이 만료되었습니다")
                owner.presentToast("로그인 세션이 만료되었습니다")
                RootSwitcher.update(.login)
            })
            .disposed(by: disposeBag)
            
    }
    
    private func style() {
        view.backgroundColor = .zw_background
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setDelegate() {
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    private func hierarchy() {
        view.addSubview(webView)
        webView.addSubview(indicator)
    }
    
    private func layout() {
        webView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}

extension FapWebViewController: WKScriptMessageHandler {
    
    //MARK: Web -> iOS 데이터 전달 방식
    //TODO: 콜백핸들러함수명에 해당하는 함수가 JS에서 실행되었을 때 아래 함수가 발동돼.
    //TODO: 만약 너가 콜백핸들러에 데이터를 전달했다면 meesage.body에 값이 실려 올거야. 형태는 JSON으로 주고받을거야.
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        let name = ListenerName(rawValue: message.name) ?? .unknown
        let body = message.body as? String
        let message = WebToAppMessage(name: name, body: body)
        webToAppMessageEvent.accept(message)
    }
}

extension FapWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    //MARK: load 완료시
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}

extension FapWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView,
                                    with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
