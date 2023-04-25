//
//  SignUpViewController_1.swift
//  Pawpet
//
//  Created by Robert Miller on 20.03.2023.
//

import UIKit
import Lottie
import FlagPhoneNumber
import FirebaseAuth

class SignUpViewController_1: BaseSignUpViewController {

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

    // MARK: Phone TF
    private let phoneTextField = FPNTextField()
    private var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    private var phoneNumber: String?

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nextVC = SignUpViewController_1_1()
        promptView.setupTitles(title: "Enter your phone number", subtitle: "This will help us verify that you are a real human and avoid malicious attacks. Also, the phone number will help you restore access to your account.")
        setupAnimationView(with: "WatchingDog")
        setupCloseButton()
        configurePhoneTF()

        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }

    private func configurePhoneTF() {
        removeTextField()

        phoneTextField.delegate = self
        phoneTextField.displayMode = .list
        phoneTextField.layer.cornerRadius = 12
        phoneTextField.backgroundColor = .backgroundColor
        phoneTextField.font = .systemFont(ofSize: 24, weight: .semibold)
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

    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(80)
            make.right.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Button logic
extension SignUpViewController_1 {
    @objc private func closeButtonTapped(_ sender: UIButton) {
        print("Dissmised")
        dismiss(animated: true)
    }
}

// MARK: FPN delegate
extension SignUpViewController_1: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {

    }

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
        listController.title = "Countries"
        listController.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneTextField.setFlag(countryCode: country.code)
        }

        let navigationViewController = UINavigationController(rootViewController: listController)
        self.present(navigationViewController, animated: true, completion: nil)
    }
}

// MARK: - AUTH Logic
extension SignUpViewController_1 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        guard phoneNumber != nil else { return }

        self.pushToVerificationVC(with: "verificationID!")

//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
//            if error != nil {
//                print(error?.localizedDescription ?? "unknown error")
//            } else {
//                print("verificationID: \(verificationID)")
//                self.pushToVerificationVC(with: verificationID!)
//            }
//        }
    }

    private func pushToVerificationVC(with verificationID: String) {
        let verificationVC = SignUpViewController_1_1()
        verificationVC.verificationID = verificationID
        self.navigationController?.pushViewController(verificationVC, animated: true)
    }
}
