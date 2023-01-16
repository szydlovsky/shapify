//
//  AuthViewController.swift
//  Shapify

import UIKit
import WebKit

final class AuthViewController: UIViewController {

    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let preferencies = WKWebpagePreferences()
        preferencies.allowsContentJavaScript = true
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        return wv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        setupWebView()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        guard let url = URL(string: AuthManager.shared.signInURL) else {
            return
        }
        self.webView.load(URLRequest(url: url))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        let components = URLComponents(string: url.absoluteString)
        
        guard let code = components?.queryItems?.filter({ item in
            item.name == "code"
        }).first?.value else {
            return
        }
        webView.isHidden = true
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                let tabBar = AppTabBarController()
                tabBar.modalPresentationStyle = .fullScreen
                self?.present(tabBar, animated: false)
            }
        }
    }
}
