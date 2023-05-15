//
//  PriceTextField.swift
//  Pawpet
//
//  Created by Robert Miller on 01.05.2023.
//

import UIKit
import SnapKit

class PriceTextField: UITextField, UITextFieldDelegate {

    var currency: String = "USD"
    let currencyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .accentColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.snp.makeConstraints { $0.height.width.equalTo(32) }
        return button
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
        setupTF()
        setupConstraints()
        setupMenu()
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    private func setupTF() {
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
    }

    private func setupConstraints() {
        addSubview(currencyButton)
        currencyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(40)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - TextField Delegate
extension PriceTextField {
    @objc private func textDidChange() {
        let textSize = (text ?? "").size(withAttributes: [.font: font!])
        let totalWidth = textSize.width + currencyButton.intrinsicContentSize.width
        let offset = (bounds.width - totalWidth - 60) / 2
        currencyButton.snp.removeConstraints()
        currencyButton.snp.remakeConstraints { make in
            make.right.equalTo(self).inset(offset)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(32)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return updatedText.count <= maxLength
    }

    func setupPrice(price: Int) {
        text = "\(price)"
        textDidChange()
    }
}

// MARK: - Currency button
extension PriceTextField {
    @objc private func currencyButtonTapped() {
        
    }

    func setupButtonTitle(with symbol: String) {
        switch symbol {
        case "$": currency = "USD"
        case "₽": currency = "RUB"
        case "₸": currency = "KZT"
        default: break
        }

        let title = NSAttributedString(
            string: symbol,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        currencyButton.setAttributedTitle(title, for: .normal)
    }
}

// MARK: - Currency choose menu
extension PriceTextField {
    private func setupMenu() {
        let USDAction = UIAction(title: "USD") { _ in
            self.setupButtonTitle(with: "$")
        }
        let RUBAction = UIAction(title: "RUB") { _ in
            self.setupButtonTitle(with: "₽")
        }
        let KZTAction = UIAction(title: "KZT") { _ in
            self.setupButtonTitle(with: "₸")
        }

        let actionsMenu = UIMenu(title: "", children: [USDAction, RUBAction, KZTAction])

        currencyButton.showsMenuAsPrimaryAction = true
        currencyButton.menu = actionsMenu
    }
}
