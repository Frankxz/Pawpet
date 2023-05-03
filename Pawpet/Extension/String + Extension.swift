//
//  String.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import Foundation

extension String {
    func geoCodeToEmoji() -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }

    func capitilizeFirstChar() -> String {
        let inputString = self
        let capitalizedString = inputString.prefix(1).uppercased() + inputString.dropFirst()
        return capitalizedString
        
    }

    func inCurrencySymbol() -> String {
        switch self {
        case "USD": return "$"
        case "RUB": return "₽"
        case "KZT": return "₸"
        default: return "$"
        }
    }
}

