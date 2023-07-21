//
//  File.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

extension UILabel {
    func setAttributedText(withString string: String,
                           boldString: String,
                           font: UIFont,
                           stringWeight: UIFont.Weight = .light,
                           boldStringWeight: UIFont.Weight = .bold ) {
        let boldAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: font.pointSize, weight: boldStringWeight)]
        let boldAttributedString = NSMutableAttributedString(string:boldString, attributes:boldAttrs)

        let normalAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: font.pointSize, weight: stringWeight)]
        let normalString = NSMutableAttributedString(string:string, attributes: normalAttrs)
        normalString.append(boldAttributedString)

        self.attributedText = normalString
    }
}
