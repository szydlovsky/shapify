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
    static let shapifyPastelPurple = UIColor(hexString: "C3AED6")!
    static let shapifyPastelBlue = UIColor(hexString: "A6E3E9")!
    static let shapifyMint = UIColor(hexString: "A8E6CF")!
    static let shapifyPink = UIColor(hexString: "E6B4DC")!
    static let shapifyYellow = UIColor(hexString: "ECD543")!
    static let shapifyRed = UIColor(hexString: "D07474")!
    static let shapifyPurple = UIColor(hexString: "9D9DF4")!
    static let shapifyLightGreen = UIColor(hexString: "ADEA50")!
    static let shapifyBlue = UIColor(hexString: "25B4F9")!
    static let shapifyBlack = UIColor(hexString: "1A1A1A")!
    
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
