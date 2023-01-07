//
//  UIViewExtensions.swift
//  Shapify

import UIKit

extension UIView {
    
    func setWidth(_ width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({
            addSubview($0)
        })
    }
}
