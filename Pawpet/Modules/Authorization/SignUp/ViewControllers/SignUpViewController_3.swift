//
//  SignUpViewController_3.swift
//  Pawpet
//
//  Created by Robert Miller on 06.04.2023.
//

import UIKit
import Lottie

class SignUpViewController_3: BaseSignUpViewController {
    // MARK: - UI components
    private var surnameTextField = AuthTextField("Surname", isSecure: true)

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promptView.setupTitles(title: "Enter your name", subtitle: "This information will be visible to all users.")
        textField.setupPlaceholder(placeholder: "Name")
        setupAnimationView(with: "WatchingDog")
        setupSurnameTF()

        nextVC = SignUpViewController_4()
    }
}

// MARK: - UI + Constraints
extension SignUpViewController_3 {
    private func setupSurnameTF() {
        view.addSubview(surnameTextField)

        surnameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }

        nextButton.snp.removeConstraints()

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(surnameTextField.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
    }
}


