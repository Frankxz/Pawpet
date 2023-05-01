//
//  PriceTextField.swift
//  Pawpet
//
//  Created by Robert Miller on 01.05.2023.
//

import UIKit
import SnapKit

class PriceTextField: UITextField, UITextFieldDelegate {

    private let currencySymbol: String = "$"
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGreen
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        borderStyle = .none
        backgroundColor = .backgroundColor
        layer.cornerRadius = 12
        delegate = self
        keyboardType = .numberPad
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 30, weight: .bold)

        attributedPlaceholder = NSAttributedString(string: "0", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)])
        textAlignment = .center

        addSubview(currencyLabel)
        currencyLabel.text = currencySymbol
        currencyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
        }

        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    @objc private func textDidChange() {
        let textSize = (text ?? "").size(withAttributes: [.font: font!])
        let totalWidth = textSize.width + currencyLabel.intrinsicContentSize.width
        let offset = (bounds.width - totalWidth - 60) / 2
        currencyLabel.snp.removeConstraints()
        currencyLabel.snp.remakeConstraints { make in
            make.right.equalTo(self).inset(offset)
            make.centerY.equalToSuperview()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10 
           let currentText = textField.text ?? ""
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
           return updatedText.count <= maxLength
    }
}
