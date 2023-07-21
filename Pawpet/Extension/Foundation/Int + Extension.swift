//
//  Int + Extension.swift
//  Pawpet
//
//  Created by Robert Miller on 03.05.2023.
//

import Foundation

extension Int {
    func formatPrice() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "

        let formattedPrice = numberFormatter.string(from: NSNumber(value: self)) ?? ""
        return formattedPrice
    }
}
