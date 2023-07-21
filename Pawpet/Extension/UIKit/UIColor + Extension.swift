//
//  UIColor + Extension.swift
//  Pawpet
//
//  Created by Robert Miller on 09.03.2023.
//

import UIKit

extension UIColor {

    // MARK: - OFTEN USED COLORS
    static let accentColor = hexColor(hex: "272727")
    static let backgroundColor = hexColor(hex: "F3F3F3")
    static let subtitleColor = hexColor(hex: "B4B4B4")
    static let errorColor = hexColor(hex: "272727")

    // MARK: - HEX INIT
    convenience init(hex: String, alpha: CGFloat? = nil) {
        var hex: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        var aValue: UInt64
        let rValue, gValue, bValue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aValue, rValue, gValue, bValue) = (255, (rgbValue >> 4 & 0xF) * 17,
                                                (rgbValue >> 4 & 0xF) * 17, (rgbValue & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aValue, rValue, gValue, bValue) = (255, rgbValue >> 16, rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
        case 8: // ARGB (32-bit)
            (aValue, rValue, gValue, bValue) = (rgbValue >> 24, rgbValue >> 16 & 0xFF,
                                                rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
        default: // gray as like systemGray
            (aValue, rValue, gValue, bValue) = (255, 123, 123, 129)
        }

        if let alpha = alpha, alpha >= 0, alpha <= 1 {
            aValue = UInt64(alpha * 255)
        }

        self.init(
            red: CGFloat(rValue) / 255,
            green: CGFloat(gValue) / 255,
            blue: CGFloat(bValue) / 255,
            alpha: CGFloat(aValue) / 255)
    }
}

// MARK: - METHOD RETURNING HEX COLOR
func hexColor(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }
    if (cString.count) != 6 { return UIColor.systemGray }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// MARK: - For random color
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 1.0
        )
    }
}
