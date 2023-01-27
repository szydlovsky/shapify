//
//  SignInViewController.swift
//  Shapify

import UIKit

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
            let tabBar = AppTabBarController()
            tabBar.modalPresentationStyle = .fullScreen
            present(tabBar, animated: false)
        }
    }
}
