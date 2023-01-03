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
                    NSAttributedString.Key.font: UIFont.appFont(ofSize: 20, isBold: true),
                    NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAttributedTitle(buttonTitle, for: .normal)
        self.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.backgroundColor = UIColor.shapifyDarkGreen
        self.tintColor = .clear
        self.layer.cornerRadius = 30
    }
}
