//
//  ColorExtensions.swift
//  Shapify

import UIKit

extension UIColor {
    
    // MARK: - App's colors

    static let shapifyGreen = UIColor(hexString: "307672")!
    static let shapifyDarkGreen = UIColor(hexString: "144D53")!
    static let shapifySuperDarkGreen = UIColor(hexString: "1A3C40")!
    static let shapifyLightBackground = UIColor(hexString: "E4EDDB")!
    static let shapifyDarkBackground = UIColor(hexString: "CCDBC0")!
    
    // MARK: - Useful functions
    
    convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
    
    func isLight() -> Bool {
        if let components = cgColor.components, components.count > 2 {
            let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
            return (brightness > 0.5)
        } else {
            guard let rgb = cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
                  let components = rgb.components,
                  components.count > 2
            else {
                return false
            }
            let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
            return (brightness > 0.5)
        }
    }
}
