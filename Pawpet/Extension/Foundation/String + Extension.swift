//
//  String.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit

extension String {
    func localize() -> String {
        NSLocalizedString(self,  comment: "")
    }

    func capitilizeFirstChar() -> String {
        let inputString = self
        let capitalizedString = inputString.prefix(1).uppercased() + inputString.dropFirst()
        return capitalizedString.localize()
        
    }

    func inCurrencySymbol() -> String {
        switch self {
        case "USD": return "$"
        case "RUB": return "₽"
        case "KZT": return "₸"
        default: return "$"
        }
    }

    func createAttributedString(withHighlightedWord word: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)

        let grayColor = UIColor.subtitleColor
        let redColor = UIColor.systemRed

        attributedString.addAttribute(.foregroundColor, value: grayColor, range: NSRange(location: 0, length: self.count))

        let nsText = self as NSString
        var searchRange = NSRange(location: 0, length: nsText.length)
        var foundRange: NSRange

        while searchRange.location < nsText.length {
            searchRange.length = nsText.length - searchRange.location
            foundRange = nsText.range(of: word, options: .caseInsensitive, range: searchRange)

            if foundRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: redColor, range: foundRange)
                searchRange.location = foundRange.location + foundRange.length
            } else {
                break
            }
        }

        return attributedString
    }

}

