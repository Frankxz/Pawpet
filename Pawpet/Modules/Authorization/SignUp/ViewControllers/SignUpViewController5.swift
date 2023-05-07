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
    var secondTextField = AuthTextField("Surname".localize(), isSecure: false)

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promptView.setupTitles(title: "Enter your name", subtitle: "This information will be visible to all users.")
        textField.setupPlaceholder(placeholder: "Name".localize())
        setupAnimationView(with: "WatchingDog")
        setupSurnameTF()

        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - UI + Constraints
extension SignUpViewController5 {
    private func setupSurnameTF() {
        view.addSubview(secondTextField)

        secondTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }

        nextButton.snp.removeConstraints()

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(secondTextField.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
    }
}

// MARK: NextButton tapped
extension SignUpViewController5 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(textField.text, forKey: "NAME")
        UserDefaults.standard.set(secondTextField.text, forKey: "SURNAME")

        let countries = GeoManager.shared.getAllCountries(localize: .ru)
        self.navigationController?.pushViewController(SignUpViewController6(geoObjects: countries, geoVCType: .country), animated: true)


    }
}

