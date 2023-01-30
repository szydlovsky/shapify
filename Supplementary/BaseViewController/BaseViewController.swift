//
//  BaseViewController.swift
//  Shapify

import UIKit

class BaseViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSettingsBarButton()
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .pageSheet
        self.present(settingsVC, animated: true)
    }
    
    func setUpSettingsBarButton() {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "customerIcon"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.setHeight(44)
        barButton.customView?.setWidth(44)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
}
