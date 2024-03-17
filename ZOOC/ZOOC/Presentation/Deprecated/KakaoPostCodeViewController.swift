//
//  KakaoPostCodeViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/08/27.
//

import UIKit
import WebKit

import SnapKit

protocol KakaoPostCodeViewControllerDelegate: AnyObject {
    func fetchPostCode(roadAddress: String, zoneCode: String)
}

final class KakaoPostCodeViewController: BaseViewController {

    // MARK: - Properties
    
    weak var delegate: KakaoPostCodeViewControllerDelegate?
    
    private var address = ""
    private var zoneCode = ""
    
    //MARK: - UI Components
    
    private var webView: WKWebView?
    private let indicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI
    private func configureUI() {
        view.backgroundColor = .white
        setAttributes()
        setContraints()
    }

    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self

        guard let url = URL(string: ExternalURL.postCodeURL),
            let webView = webView
            else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }

    private func setContraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)

        webView.addSubview(indicator)

        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension KakaoPostCodeViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            address = data["roadAddress"] as? String ?? ""
            zoneCode = data["zonecode"] as? String ?? ""
        }
        
        delegate?.fetchPostCode(roadAddress: address, zoneCode: zoneCode)
        self.dismiss(animated: true, completion: nil)
    }
}

extension KakaoPostCodeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}

