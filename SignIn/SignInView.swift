//
//  SignInView.swift
//  Shapify

import UIKit

final class SignInView: BaseView {
    
    var onButtonPress: (() -> Void)?
    
    private let logoView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "shapifyLogo")
        $0.contentMode = .scaleAspectFit
        $0.setWidth(.screenWidth * 0.55)
        $0.setHeight(.screenWidth * 0.55)
    }
    
    private let nameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 24, isBold: true)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "Shapify"
        $0.numberOfLines = 1
    }
    
    private let signInLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 36, isBold: true)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "Sign in to\nSpotify"
        $0.numberOfLines = 0
    }
    
    private let signInButton = UIButton(type: .system).then {
        $0.setUpRoundedButton(title: "Sign in", withSpotiIcon: true)
        $0.setWidth(.screenWidth * 0.8)
    }
    
    override init() {
        super.init()
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .shapifyLightBackground
        
        addSubviews([logoView, nameLabel, signInLabel, signInButton])
        
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.defaultMargin),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            nameLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 10),
            
            signInLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            
            signInButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -2 * Constants.defaultMargin),
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        signInButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        onButtonPress?()
    }
}
