//
//  UIViewControllerExtensions.swift
//  Shapify

import UIKit

extension UIViewController {
 
    func showPopup(
        message: String,
        buttonTitle: String,
        action: (()->Void)? = nil
    ) {
        let vc = PopupViewController(
            model: .init(
                message: message,
                buttonTitle: buttonTitle,
                action: action
            )
        )
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
    }
    
}
