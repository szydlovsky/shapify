//
//  PopupView.swift
//  Shapify

import UIKit

final class PopupView: BaseView {
    
    var onButtonPress: (() -> Void)?
    var onClosePress: (() -> Void)?
    
    let containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifyLightBackground
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.shapifySuperDarkGreen.cgColor
        $0.widthAnchor.constraint(equalToConstant: .screenWidth * 0.6).isActive = true
        $0.heightAnchor.constraint(equalToConstant: .screenWidth * 0.3).isActive = true
    }
    
    private let messageLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.8
        
    }
    
    private let button = UIButton(type: .system).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifyDarkGreen
        $0.titleLabel?.font = .appFont(ofSize: 14, isBold: true)
        $0.setTitleColor(.shapifyLightBackground, for: .normal)
        $0.widthAnchor.constraint(equalToConstant: .screenWidth * 0.23).isActive = true
        $0.heightAnchor.constraint(equalToConstant: .screenWidth * 0.07).isActive = true
        $0.layer.cornerRadius = 5
    }
    
    private let closeButton = UIButton(type: .system).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        let img = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysOriginal)
        $0.setImage(img, for: .normal)
        $0.widthAnchor.constraint(equalToConstant: 18).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    override init() {
        super.init()
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .black.withAlphaComponent(0.5)
        
        addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(button)
        containerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            button.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            messageLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -3),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
        
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPressed)))
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePressed)))
    }
    
    @objc private func buttonPressed() {
        onButtonPress?()
    }
    
    @objc private func closePressed() {
        onClosePress?()
    }
    
    func configure(
        message: String,
        buttonTitle: String
    ) {
        messageLabel.text = message
        button.setTitle(buttonTitle, for: .normal)
    }
}
