//
//  RoundedButtonExtension.swift
//  Shapify

import UIKit

extension UIButton {
    func setUpRoundedButton(title: String, withSpotiIcon: Bool = false) {
        let buttonTitle =
            NSMutableAttributedString(
                string: title,
                attributes: [
                    NSAttributedString.Key.font: UIFont.appFont(ofSize: 20, isBold: true),
                    NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAttributedTitle(buttonTitle, for: .normal)
        self.setHeight(64)
        self.backgroundColor = UIColor.shapifySuperDarkGreen
        self.tintColor = .clear
        self.layer.cornerRadius = 30
        
        if withSpotiIcon {
            let imgView = UIImageView().then {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.setHeight(37)
                $0.setWidth(37)
                $0.contentMode = .scaleAspectFit
                $0.image = UIImage(named: "spotiIcon")
            }
            addSubview(imgView)
            NSLayoutConstraint.activate([
                imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
                imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
}
