//
//  SignUpViewController3.swift
//  Pawpet
//
//  Created by Robert Miller on 25.04.2023.
//

import UIKit
import Lottie
import FlagPhoneNumber
import FirebaseAuth
import Firebase

class SignUpViewController3: BaseSignUpViewController {

    // MARK: Phone TF
    public let phoneTextField = FPNTextField()
    private var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    public var phoneNumber: String?

    // MARK: AlertView
    public let alertView = ErrorAlertView()

    public var confirmationVC = SignUpViewController4()

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promptView.setupTitles(title: "Enter your phone number", subtitle: "This will help us verify that you are a real human and avoid malicious attacks. Also, the phone number will help you restore access to your account.")
        setupAnimationView(with: "WatchingDog")
        configurePhoneTF()
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    private func configurePhoneTF() {
        removeTextField()

        phoneTextField.delegate = self
        phoneTextField.displayMode = .list
        phoneTextField.layer.cornerRadius = 12
        phoneTextField.backgroundColor = .backgroundColor
        phoneTextField.font = .systemFont(ofSize: 18, weight: .semibold)
        phoneTextField.setFlag(countryCode: .RU)

        nextButton.alpha = 0.9
        nextButton.isEnabled = false

        setupConstraints()
    }

    private func setupConstraints() {
        
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(70)
        }

        nextButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.height.equalTo(70)
        }

    }
}

// MARK: FPN delegate
extension SignUpViewController3: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) { }

    func fpnDidValidatePhoneNumber(textField: FlagPhoneNumber.FPNTextField, isValid: Bool) {
        if isValid {
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 1
                self.nextButton.isEnabled = true
                self.phoneNumber = textField.getFormattedPhoneNumber(format: .E164)
                print("phoneNumber: \(self.phoneNumber ?? "")")
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 0.9
                self.nextButton.isEnabled = false
            }
        }
    }

    func fpnDisplayCountryList() {
        listController.title = "Countries".localize()
        listController.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneTextField.setFlag(countryCode: country.code)
        }

        let navigationViewController = UINavigationController(rootViewController: listController)
        self.present(navigationViewController, animated: true, completion: nil)
    }
}

// MARK: - AUTH Logic
extension SignUpViewController3 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        guard phoneNumber != nil else { return }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                self.alertView.showAlert(with: "Oops... Error!", message: error!.localizedDescription, on: self)
            } else {
                self.pushToVerificationVC(with: verificationID!)
            }
        }
    }

    private func pushToVerificationVC(with verificationID: String) {
        confirmationVC.verificationID = verificationID
        self.navigationController?.pushViewController(confirmationVC, animated: true)
    }

    @objc private func dismissAlertView() {
        alertView.dismissAlertView()
    }
}
