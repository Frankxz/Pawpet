//
//  PNChangeViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 29.04.2023.
//

import UIKit
import FlagPhoneNumber

class PNChangeViewController1: SignUpViewController3 {

    // MARK: Button
    private lazy var cancelButton: UIBarButtonItem = {
        let customAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.accentColor]
        let saveButtonTitle = NSAttributedString(string: "Cancel".localize(), attributes: customAttributes)
        let saveButton = UIButton(type: .system)
        saveButton.setAttributedTitle(saveButtonTitle, for: .normal)
        saveButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        return saveBarButton
    }()
    
    private let passwordTextField = PawTextField("Your password for confirmation...", isSecure: true)
    private var password = ""

    private var isValidNumber: Bool = false
    var callback: ()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        navigationItem.rightBarButtonItem = cancelButton
        promptView.setupTitles(title: "Enter your new phone number", subtitle: "Phone number will help us verify that you are a real human and avoid malicious attacks. Also, the phone number will help you restore access to your account.")
        setupPasswordTF()
        confirmationVC = PNChangeViewController2()
        confirmationVC.callback = callback
    }

    private func setupPasswordTF() {
        view.addSubview(passwordTextField)
        passwordTextField.tag = 1
        passwordTextField.delegate = self
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
        }

        nextButton.snp.removeConstraints()
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Password TF
extension PNChangeViewController1 {
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField.tag == 1 {
            guard let text = passwordTextField.text else {
                nextButton.alpha = 0.95
                nextButton.isEnabled = false
                return true
            }
            if text.isEmpty {
                nextButton.alpha = 0.95
                nextButton.isEnabled = false
            } else {
                password = "\(text)\(string)"
                print(password)
                if isValidNumber {
                    nextButton.alpha = 1
                    nextButton.isEnabled = true
                }
            }
        }
        return true
    }

    override func fpnDidValidatePhoneNumber(textField: FlagPhoneNumber.FPNTextField, isValid: Bool) {
        isValidNumber = isValid
        guard let text = passwordTextField.text else {return}
        if isValidNumber {
            self.phoneNumber = phoneTextField.getFormattedPhoneNumber(format: .E164)
        }
        if isValidNumber && !text.isEmpty {
            nextButton.alpha = 1
            nextButton.isEnabled = true
        } else {
            nextButton.alpha = 0.95
            nextButton.isEnabled = false
        }
    }

    override func nextButtonTapped(_ sender: UIButton) {
        UserManager.shared.reauthenticateUser(password: password) { result in
            switch result {
            case .success:
                print("User reauthenticated successfully")
                super.nextButtonTapped(sender)
            case .failure(let error):
                self.alertView.showAlert(with: "Oops! Error...", message: error.localizedDescription, on: self)
            }
        }
    }
}

