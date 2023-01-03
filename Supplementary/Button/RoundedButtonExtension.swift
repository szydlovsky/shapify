//
//  RoundedButtonExtension.swift
//  Shapify

import UIKit

extension UIButton {
    func setUpRoundedButton(title: String) {
        let buttonTitle =
            NSMutableAttributedString(
                string: title,
                attributes: [
                    NSAttributedString.Key.font: UIFont.appFont(ofSize: 20, isBold: false),
                    NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAttributedTitle(buttonTitle, for: .normal)
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.backgroundColor = UIColor.black
        self.tintColor = .clear
        self.layer.cornerRadius = 30
    }
}
