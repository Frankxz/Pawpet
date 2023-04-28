//
//  SignUpViewController5.swift
//  Pawpet
//
//  Created by Robert Miller on 06.04.2023.
//

import UIKit
import Lottie

class SignUpViewController5: BaseSignUpViewController {
    // MARK: - UI components
    private var surnameTextField = AuthTextField("Surname", isSecure: false)

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promptView.setupTitles(title: "Enter your name", subtitle: "This information will be visible to all users.")
        textField.setupPlaceholder(placeholder: "Name")
        setupAnimationView(with: "WatchingDog")
        setupSurnameTF()

        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - UI + Constraints
extension SignUpViewController5 {
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

// MARK: NextButton tapped
extension SignUpViewController5 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(textField.text, forKey: "NAME")
        UserDefaults.standard.set(surnameTextField.text, forKey: "SURNAME")
        navigationController?.pushViewController(SignUpViewController6(geoObjects: Country.createCountries(), geoVCType: .country), animated: true)
    }
}

