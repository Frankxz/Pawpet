//
//  PriceSelectionView.swift
//  Pawpet
//
//  Created by Robert Miller on 03.05.2023.
//

import UIKit

class PriceSelectionView: UIView {

    // MARK: - PromptView
    private var promptView = PromptView(with: "Enter the price",
                                        and: "If you don't want to set a price, and want to make it free, click on the toggler to set the position to free. Keep in mind, you can change the displayed currency by clicking on the emblem of the current currency", titleSize: 32)

    // MARK: - Control
    private let isFreeLabel: UILabel = {
        let label = UILabel()
        label.text = "Set no price and make free:".localize()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .accentColor
        return label
    }()
    
    // MARK: - Button
    lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Post publication")
        return button
    }()

    // MARK: - TextField
    var priceTF = PriceTextField(frame: .zero)

    lazy var freeToggler: UISwitch = {
        let toggler = UISwitch()
        toggler.addTarget(self, action: #selector(freeTogglerTapped), for: .touchUpInside)
        toggler.isOn = false
        return toggler
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupConstraints()
        addKeyBoardObservers()
        promptView.subtitleLabel.textAlignment = .natural
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension PriceSelectionView {
    func setupPrice(price: Int) {
        if price != 0 {
            priceTF.setupPrice(price: price)
        }
    }

    func setupCurrencySymbol(with curr: String = "") {
        var currency = curr
        if curr.isEmpty {
            currency = UserManager.shared.user.currency ?? "RUB"
        }
        switch currency {
        case "RUB": priceTF.setupButtonTitle(with: "₽")
        case "USD": priceTF.setupButtonTitle(with: "$")
        case "KZT": priceTF.setupButtonTitle(with: "₸")
        default:
            break
        }
    }

    private func setupConstraints() {
        addSubview(promptView)
        addSubview(priceTF)
        addSubview(freeToggler)
        addSubview(isFreeLabel)
        addSubview(nextButton)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview()
        }

        priceTF.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(freeToggler.snp.bottom).offset(20)
            make.height.equalTo(70)
        }

        isFreeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }

        freeToggler.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(isFreeLabel.snp.centerY)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - KeyBoard logic
extension PriceSelectionView {
    private func addKeyBoardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            nextButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(keyboardHeight + 10)
                make.height.equalTo(70)
            }

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        nextButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(70)
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - freeToggler Logic
extension PriceSelectionView {
    @objc func freeTogglerTapped() {
        freeToggler.isOn ? makePriceTFFree() : unmakePriceTFFree()
    }

    private func makePriceTFFree() {
        UIView.animate(withDuration: 0.25, animations: {
            self.priceTF.alpha = 0
            self.priceTF.currencyButton.alpha = 0

        }) { ended in
            if ended {
                self.priceTF.textColor = .white
                self.priceTF.text = "FREE".localize()
                UIView.animate(withDuration: 0.25) {
                    self.priceTF.backgroundColor = .systemGreen
                    self.priceTF.alpha = 1
                }
            }
        }
    }

    private func unmakePriceTFFree() {
        UIView.animate(withDuration: 0.25, animations: {
            self.priceTF.alpha = 0
        }) { ended in
            if ended {
                self.priceTF.currencyButton.alpha = 1
                self.priceTF.text = nil
                self.priceTF.textColor = .accentColor
                self.priceTF.backgroundColor = .backgroundColor
                UIView.animate(withDuration: 0.25) {
                    self.priceTF.alpha = 1
                }
            }
        }
    }
}
