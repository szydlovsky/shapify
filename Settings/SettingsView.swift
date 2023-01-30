//
//  SettingsView.swift
//  Shapify

import UIKit

final class SettingsView: BaseView {
    
    private let cutView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifyDarkBackground
    }
    
    private let upperRect = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifySuperDarkGreen
        $0.layer.cornerRadius = 3
        $0.setWidth(.screenWidth * 0.5)
        $0.setHeight(7)
    }
    
    private let infoLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 24, isBold: true)
        $0.textColor = .shapifyBlack
        $0.textAlignment = .center
        $0.text = "Settings"
        $0.numberOfLines = 0
    }
    
    private let profilePicture = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.loadImage(urlString: ProfileManager.shared.profile?.imageURL)
        $0.setWidth(0.5 * .screenWidth)
        $0.setHeight(0.5 * .screenWidth)
        $0.layer.cornerRadius = 0.25 * .screenWidth
        $0.clipsToBounds = true
    }
    
    private let usernameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 20)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = ProfileManager.shared.profile?.username ?? "username"
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let emailLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 20)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = ProfileManager.shared.profile?.email ?? "e-mail address"
        $0.adjustsFontSizeToFitWidth = true
    }
    
    lazy var logOutButton = UIButton().then {
        $0.setUpRoundedButton(title: "Log out")
        $0.setWidth(0.8 * .screenWidth)
    }
    
    override init() {
        super.init()
        setUp()
    }

    private func setUp() {
        backgroundColor = .clear
        
        addSubview(cutView)
        cutView.addSubviews([upperRect, infoLabel, profilePicture, usernameLabel, emailLabel, logOutButton])
        
        NSLayoutConstraint.activate([
            cutView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cutView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cutView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cutView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .screenHeight * 0.05),
            
            upperRect.centerXAnchor.constraint(equalTo: cutView.centerXAnchor),
            upperRect.topAnchor.constraint(equalTo: cutView.topAnchor, constant: 15),
            
            infoLabel.centerXAnchor.constraint(equalTo: cutView.centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: cutView.leadingAnchor, constant: Constants.defaultMargin),
            infoLabel.trailingAnchor.constraint(equalTo: cutView.trailingAnchor, constant: -Constants.defaultMargin),
            infoLabel.topAnchor.constraint(equalTo: upperRect.bottomAnchor, constant: Constants.defaultMargin),
            
            profilePicture.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePicture.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: .screenHeight * 0.1),
            
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: .screenHeight * 0.1),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: .screenHeight * 0.05),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            
            logOutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logOutButton.bottomAnchor.constraint(equalTo: cutView.bottomAnchor, constant: -0.075 * .screenHeight)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cutView.roundCorners(corners: [.topLeft, .topRight], radius: .screenWidth * 0.2)
    }
}
