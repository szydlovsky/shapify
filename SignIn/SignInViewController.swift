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
}
