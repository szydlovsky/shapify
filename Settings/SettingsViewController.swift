//
//  SettingsViewController.swift
//  Shapify

import UIKit

class SettingsViewController: UIViewController {
    
    private let mainView = SettingsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    func setUp() {
        navigationController?.navigationBar.isHidden = true
        mainView.logOutButton.addTarget(self, action: #selector (logOutPressed), for: .touchUpInside)
    }
    
    @objc private func logOutPressed() {
        let action = ProfileManager.shared.signOut
        self.showPopup(message: "Do you really want to log out?", buttonTitle: "Yes", action: action)
    }
    
}
