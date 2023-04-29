//
//  EmailChangeViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 29.04.2023.
//

import UIKit

protocol EmailChangeDelegate {
    func showSuccessAlert(with newEmail: String)
}

class EmailChangeViewController: SignUpViewController1 {

    // MARK: AlertView
    private let alertView = ErrorAlertView()

    private let passwordTextField = AuthTextField("Your password for confirmation...", isSecure: true)
    
    public var editVCDelegate: EmailChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        nextButton.setupTitle(for: "Change")
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        promptView.setupTitles(title: "Enter your new email", subtitle: "This will help you to enter the application.")
        closeButton.removeFromSuperview()
        animationView?.removeFromSuperview()
        setupAnimationView(with: "Loading", topOffset: 80, loopMode: .playOnce, beginPlay: false, siteSize: 260)
        
        setupPasswordTF()
    }

    private func setupPasswordTF() {
        view.addSubview(passwordTextField)
        passwordTextField.tag = 1
        passwordTextField.delegate = self
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }

        nextButton.snp.removeConstraints()
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
    }
}

// MARK: - Update logic
extension EmailChangeViewController {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        showAnimationView()
        guard let password = passwordTextField.text else {return}

        FireStoreManager.shared.reauthenticateUser(password: password) { result in
            switch result {
            case .success:
                print("User reauthenticated successfully")
                self.makeUpdate()
            case .failure(let error):
                print(error.localizedDescription)
                self.alertView.showAlert(with: "Ooops... error!", message: error.localizedDescription, on: self)
                self.hideAnimationView()
            }
        }
    }

    private func makeUpdate() {
        print("NEW email: \(textField.text ?? "")")
        FireStoreManager.shared.updateEmail(to: textField.text!) { result in
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
                self.editVCDelegate?.showSuccessAlert(with: self.textField.text!)
            case .failure(let error):
                print(error.localizedDescription)
                self.alertView.showAlert(with: "Ooops... error!", message: error.localizedDescription, on: self)
                self.hideAnimationView()
            }
        }
    }

    @objc private func dismissAlertView() {
        alertView.dismissAlertView()
    }
}

// MARK: - Password TF
extension EmailChangeViewController {
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            print("Editing passwordTextField")
            guard let text = passwordTextField.text else {
                nextButton.alpha = 0.95
                nextButton.isEnabled = false
                return true
            }
            if text.isEmpty {
                nextButton.alpha = 0.95
                nextButton.isEnabled = false
            } else {
                nextButton.alpha = 1
                nextButton.isEnabled = true
            }
        }
        return true
    }
}

// MARK: Animation View
extension EmailChangeViewController {
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
