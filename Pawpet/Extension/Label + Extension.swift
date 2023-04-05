//
//  File.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

extension UILabel {
    func setAttributedText(withString string: String, boldString: String, font: UIFont) {
        let boldAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: font.pointSize, weight: .bold)]
        let boldAttributedString = NSMutableAttributedString(string:boldString, attributes:boldAttrs)

        let normalAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: font.pointSize, weight: .light)]
        let normalString = NSMutableAttributedString(string:string, attributes: normalAttrs)
        normalString.append(boldAttributedString)

        self.attributedText = normalString
    }
}
