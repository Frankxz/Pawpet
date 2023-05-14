//
//  AuthTextField.swift
//  Pawpet
//
//  Created by Robert Miller on 17.03.2023.
//

import UIKit

class PawTextField: UITextField {

    init(_ placeholder: String = "", isSecure: Bool = false,
         _ color: UIColor = .accentColor.withAlphaComponent(0.8),
         _ fontSize: CGFloat = 18) {
        super.init(frame: .zero)

        setLeftPaddingPoints(32)
        setRightPaddingPoints(32)

        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.subtitleColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .bold)
            ]
        )

        textColor = color
        layer.cornerRadius = 12
        backgroundColor = .backgroundColor
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)

        isSecureTextEntry = isSecure
        autocapitalizationType = .none
        autocorrectionType = .no

        self.snp.makeConstraints { $0.height.equalTo(70) }
    }

    public func setupPlaceholder(placeholder: String) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.subtitleColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)
            ]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
