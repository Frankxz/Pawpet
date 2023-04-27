//
//  SignUpViewController2.swift
//  Pawpet
//
//  Created by Robert Miller on 25.04.2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController2: BaseSignUpViewController {

    public var email: String!
    private var password: String?

    private let nextViewController = SignUpViewController3()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        promptView.setupTitles(title: "Create your password", subtitle: "This will help you to enter the application.")
        setupAnimationView(with: "WatchingDog")
        textField.setupPlaceholder(placeholder: "••••••")
        textField.isSecureTextEntry = true
        textField.delegate = self

        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        nextButton.alpha = 0.95
        nextButton.isEnabled = false
        print("EMAIL: \(email ?? "")")
    }
}

// MARK: - AUTH
extension SignUpViewController2 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        print(email)
        Auth.auth().createUser(withEmail: email, password: textField.text!) { (result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("User created: \(result?.user.uid ?? "")")
                self.navigationController?.pushViewController(SignUpViewController3(), animated: true)
            }
        }
    }
}

// MARK: - Password Validation
extension SignUpViewController2: UITextFieldDelegate {
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.password = textField.text
        self.nextVC = nextViewController
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isValidPassword(textField.text ?? "") {
            nextButton.alpha = 1
            nextButton.isEnabled = true
        } else {
            nextButton.alpha = 0.95
            nextButton.isEnabled = false
        }
        return true
    }
}
