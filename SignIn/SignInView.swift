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
            signInLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            nameLabel.bottomAnchor.constraint(equalTo: signInLabel.topAnchor, constant: -70),
            
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10),
            
            signInButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -2 * Constants.defaultMargin),
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        signInButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        onButtonPress?()
    }
}
