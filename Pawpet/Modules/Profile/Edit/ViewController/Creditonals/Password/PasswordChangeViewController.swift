//
//  PasswordChangeViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 29.04.2023.
//

import UIKit

protocol PasswordChangeDelegate {
    func showSuccesAlert()
}

class PasswordChangeViewController: SignUpViewController5 {

    // MARK: AlertView
    private let alertView = ErrorAlertView()

    var editVCDelegate: PasswordChangeDelegate?

    var isValidNewPass = false
    var isValidOldPass = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        promptView.setupTitles(title: "Enter your new password", subtitle: "Also you will need to enter your old password to confirm. \n\n Don't forget about password requirements:\n  1. Minimum length - 8 characters\n  2. Contains at least one capital letter\n  3. Contains at least one lowercase letter\n  4. Contains at least one number")

        textField.tag = 0
        secondTextField.tag = 1

        textField.delegate = self
        secondTextField.delegate = self

        textField.isSecureTextEntry = true
        secondTextField.isSecureTextEntry = true

        textField.setupPlaceholder(placeholder: "OLD password")
        secondTextField.setupPlaceholder(placeholder: "NEW password")

        nextButton.setupTitle(for: "Change")
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        nextButton.alpha = 0.95
        nextButton.isEnabled = false

        animationView?.removeFromSuperview()
        setupAnimationView(with: "Loading", topOffset: 0, loopMode: .playOnce, beginPlay: false, siteSize: 260)
    }
}

// MARK: - Button logic
extension PasswordChangeViewController {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        showAnimationView()

        guard let password = textField.text else {
            hideAnimationView()
            return
        }

        UserManager.shared.reauthenticateUser(password: password) { result in
            switch result {
            case .success:
                print("User reauthenticated successfully")
                self.makeUpdate()
            case .failure(let error):
                self.hideAnimationView()
                self.alertView.showAlert(with: "Oops! Error...", message: error.localizedDescription, on: self)
            }
        }
    }

    @objc private func dismissAlertView() {
        alertView.dismissAlertView()
    }

    private func makeUpdate() {
        guard let newPassword = secondTextField.text else { return }
        UserManager.shared.updatePassword(to: newPassword) { result in
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
                self.editVCDelegate?.showSuccesAlert()
            case .failure(let error):
                self.hideAnimationView()
                self.alertView.showAlert(with: "Oops! Error...", message: error.localizedDescription, on: self)
            }
        }
    }
}

// MARK: - Password Validation
extension PasswordChangeViewController: UITextFieldDelegate {
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if isValidPassword("\(text)\(string)") {
            textField.tag == 0 ? (isValidOldPass = true) : (isValidNewPass = true)
        } else {
            textField.tag == 0 ? (isValidOldPass = false) : (isValidNewPass = false)
        }

        if isValidNewPass && isValidOldPass {
            nextButton.alpha = 1
            nextButton.isEnabled = true
        } else {
            nextButton.alpha = 0.95
            nextButton.isEnabled = false
        }
        return true
    }
}

// MARK: Animation View
extension PasswordChangeViewController {
    func showAnimationView() {
        self.animationView?.play()
        self.animationView?.isHidden = false
    }

    func hideAnimationView() {
        self.animationView?.tintColor = .red
        self.animationView?.stop()
        self.animationView?.isHidden = true
    }
}
