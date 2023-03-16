//
//  WelcomeViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 09.03.2023.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    // MARK: - Labels
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Here you'll find a pet 🐶"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .subtitleColor
        return label
    }()

    private var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have account ?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .subtitleColor
        return label
    }()


    // MARK: - TextFields
    private var emailTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .backgroundColor
        textField.setLeftPaddingPoints(32)
        textField.setRightPaddingPoints(32)
        textField.attributedPlaceholder = NSAttributedString(
            string: "email@mail.com",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.subtitleColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ]
        )
        textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textField.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()

    private var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .backgroundColor
        textField.setLeftPaddingPoints(32)
        textField.setRightPaddingPoints(32)
        textField.attributedPlaceholder = NSAttributedString(
            string: "•••••••••",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.subtitleColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ]
        )
        textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textField.textColor = UIColor.accentColor.withAlphaComponent(0.8)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        return textField
    }()

    // MARK: - Buttons
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = 16
        button.backgroundColor = .accentColor
        button.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
        let title = NSAttributedString(
            string: "Sign in",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.subtitleColor
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    private lazy var forgotButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(forgotButtonTapped(_:)), for: .touchUpInside)
        let title = NSAttributedString(
            string: "Forgot password ?",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.accentColor.withAlphaComponent(0.8)
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        let title = NSAttributedString(
            string: "Sign up now !",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.accentColor.withAlphaComponent(0.8)
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateView()
    }
}

// MARK: - UI
extension WelcomeViewController {
    private func configurateView() {
        view.backgroundColor = .white
        makeConstraints()
    }

    private func makeConstraints() {
        let labelStackView = getLabelStackView()
        let textFieldsStackView = getTextFieldsStackView()
        let signUpStackView = getSignUpStackView()

        view.addSubview(labelStackView)
        view.addSubview(textFieldsStackView)
        view.addSubview(signUpStackView)
        view.addSubview(forgotButton)
        view.addSubview(signInButton)

        labelStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(200)
        }

        textFieldsStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(labelStackView.snp.bottom).offset(24)
            make.height.equalTo(160)
        }

        forgotButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.top.equalTo(textFieldsStackView.snp.bottom).offset(12)
        }

        signInButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(forgotButton.snp.bottom).offset(24)
            make.height.equalTo(70)
        }

        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
    }

    private func getLabelStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        return stackView
    }

    private func getTextFieldsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20

        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)

        return stackView
    }

    private func getSignUpStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2

        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(signUpButton)

        return stackView
    }
}

// MARK: - Buttons logic
extension WelcomeViewController {
    @objc private func signInButtonTapped(_ sender: UIButton) {

    }

    @objc private func signUpButtonTapped(_ sender: UIButton) {

    }

    @objc private func forgotButtonTapped(_ sender: UIButton) {

    }
}
