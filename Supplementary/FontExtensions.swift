//
//  FontExtensions.swift
//  Shapify

import UIKit

extension UIFont {
    static func appFont(ofSize size: CGFloat = 36, isBold: Bool = false) -> UIFont {
        isBold
            ? UIFont(name: "Spoof-Bold", size: size)!
            : UIFont(name: "Spoof-Regular", size: size)!
    }
}
