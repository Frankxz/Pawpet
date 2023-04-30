//
//  PasswordResetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 30.04.2023.
//

import UIKit

class PasswordResetViewController: SignUpViewController1 {

    private var email = ""
    var callBack: ()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.removeFromSuperview()
        promptView.setupTitles(title: "Enter your email", subtitle: "We will send you email with instructions to reset your password.")
        nextButton.setupTitle(for: "Reset password")
    }

    override func nextButtonTapped(_ sender: UIButton) {
        FireStoreManager.shared.sendPasswordResetToEmail(email: email) { result in
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
                self.callBack()
            case .failure(let error):
                let alertView = ErrorAlertView()
                alertView.showAlert(with: "Oops! Error..", message: error.localizedDescription, on: self)
            }
        }
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        email = (textField.text ?? "") + string
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
