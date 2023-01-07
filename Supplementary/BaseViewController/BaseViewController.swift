//
//  BaseViewController.swift
//  Shapify

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSettingsBarButton()
    }
    
    func setUpSettingsBarButton() {
        var button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "customerIcon"), for: .normal)
        button.tintColor = .black
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.setHeight(44)
        barButton.customView?.setWidth(44)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
}
