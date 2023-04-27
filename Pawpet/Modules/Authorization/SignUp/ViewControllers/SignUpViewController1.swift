//
//  SignUpViewController1.swift
//  Pawpet
//
//  Created by Robert Miller on 25.04.2023.
//

import UIKit

class SignUpViewController1: BaseSignUpViewController {
    // MARK: - Button
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .large)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .accentColor
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .backgroundColor
        button.layer.cornerRadius = 16
        return button
    }()

    private let nextViewController = SignUpViewController2()

    override func viewDidLoad() {
        super.viewDidLoad()

        promptView.setupTitles(title: "Enter your email", subtitle: "This will help you to enter the application.")
        textField.setupPlaceholder(placeholder: "email@mail.com")
        setupAnimationView(with: "WatchingDog")
        setupCloseButton()

        textField.delegate = self

        nextButton.alpha = 0.9
        nextButton.isEnabled = false
    }
}


//MARK: - Email validation
extension SignUpViewController1: UITextFieldDelegate {
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        nextViewController.email = textField.text
        self.nextVC = nextViewController
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isValidEmail(textField.text ?? "") {
            nextButton.alpha = 1
            nextButton.isEnabled = true
        } else {
            nextButton.alpha = 0.95
            nextButton.isEnabled = false
        }
        return true
    }
}

// MARK: - Close button logic
extension SignUpViewController1 {
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(80)
            make.right.equalToSuperview().inset(20)
        }
    }

    @objc private func closeButtonTapped(_ sender: UIButton) {
        print("Dissmised")
        dismiss(animated: true)
    }
}
