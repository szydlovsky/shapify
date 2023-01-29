//
//  SettingsView.swift
//  Shapify

import UIKit

final class SettingsView: UIView {
    
    private let infoLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 36, isBold: true)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "Settings"
        $0.numberOfLines = 0
    }
    
    private let profilePicture = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let urlString = ProfileManager.shared.profile?.imageURL
        let url = URL(string: urlString!)!
        let data = try? Data(contentsOf: url)
            if let data = data {
                $0.image = UIImage(data: data)
            } else {
                $0.image = UIImage(named: "customerIcon")
            }
        $0.setWidth(0.5 * .screenWidth)
        $0.layer.cornerRadius = 0.25 * .screenWidth
        $0.clipsToBounds = true
    }
    
    private let usernameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 28)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = ProfileManager.shared.profile?.username ?? "username"
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let emailLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 28)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = ProfileManager.shared.profile?.email ?? "e-mail address"
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let logOutButton = UIButton().then {
        $0.setUpRoundedButton(title: "Log out")
    }
    
    public init() {
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    
    required public init?(coder: NSCoder) { nil }
    
    private func setUp() {
        backgroundColor = .shapifyLightBackground
        
        addSubviews([infoLabel, profilePicture, usernameLabel, emailLabel, logOutButton])
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            infoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.defaultMargin * 2),
            
            profilePicture.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePicture.heightAnchor.constraint(equalTo: profilePicture.widthAnchor),
            profilePicture.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: Constants.defaultMargin * 2),
            
            usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: Constants.defaultMargin * 2),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: Constants.defaultMargin),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            
            logOutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            logOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            logOutButton.topAnchor.constraint(lessThanOrEqualTo: emailLabel.bottomAnchor, constant: Constants.defaultMargin * 4),
            logOutButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -0.125 * .screenHeight)
        ])
    }
    
}
