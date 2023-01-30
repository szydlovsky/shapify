//
//  SignInViewController.swift
//  Shapify

import UIKit
import SwiftLoader

final class SignInViewController: UIViewController {
    
    private let mainView = SignInView()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.onButtonPress = { [weak self] in
            let vc = AuthViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.navigationItem.largeTitleDisplayMode = .never
            self?.push(vc)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AuthManager.shared.isLoggedIn {
            setLoaderConfig()
            ProfileManager.shared.setProfile()
            if ProfileManager.shared.profile == nil {
                DispatchQueue.main.async {
                    SwiftLoader.show(title: "Preparing...", animated: true)
                }
                APICaller.shared.getProfile() { [weak self] error in
                    SwiftLoader.hide()
                    if let _ = error {
                        self?.showPopup(
                            message: "Network connection failure occured.",
                            buttonTitle: "OK")
                    } else {
                        self?.showAppTabBar(animated: true)
                    }
                }
            } else {
                showAppTabBar(animated: false)
            }
        }
    }
    
    private func showAppTabBar(animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            let tabBar = AppTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            self?.present(tabBar, animated: animated)
        }
    }
    
    private func setLoaderConfig() {
        var config = SwiftLoader.Config()
        config.size = .screenWidth * 0.5
        config.spinnerColor = .shapifyLightBackground
        config.backgroundColor = .shapifyDarkGreen
        config.cornerRadius = .screenWidth * 0.1
        config.titleTextFont = .appFont(ofSize: 16, isBold: false)
        config.titleTextColor = .shapifyLightBackground
        SwiftLoader.setConfig(config)
    }
}
