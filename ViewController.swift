//
//  ViewController.swift
//  Shapify

import UIKit

class ViewController: UIViewController {

    private let testButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        setup()
    }
    
    #warning("Maybe check in App Delegate? But then need to add completion in the AuthController to run it when access token got received")
    override func viewWillAppear(_ animated: Bool) {
        if AuthManager.shared.isLoggedIn {
            let nc = UINavigationController(rootViewController: DummyViewController())
            nc.modalPresentationStyle = .fullScreen
            present(nc, animated: false)
        }
    }

    private func setup() {
        testButton.addTarget(self, action: #selector(logInDidTap), for: .touchUpInside)
        testButton.configuration = .filled()
    }
    
    private func layout() {
        view.addSubview(testButton)

        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - Actions
extension ViewController {
    @objc private func logInDidTap() {
        let vc = AuthViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
