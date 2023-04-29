//
//  SignUpViewController4.swift
//  Pawpet
//
//  Created by Robert Miller on 25.04.2023.
//


import UIKit
import FirebaseAuth

class SignUpViewController4: BaseSignUpViewController {

    public let textView = UITextView()
    public var verificationID: String!
    
    var callback: ()->() = {}
    
    // MARK: AlertView
    public let alertView = ErrorAlertView()

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nextVC = SignUpViewController5()
        promptView.setupTitles(title: "Enter the verification code.", subtitle: "The verification code has been sent to your phone number. It should come within 5 minutes. If you don't receive a verification code, please try again later.")
        setupAnimationView(with: "WatchingDog")
        setupView()

        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: UI + Constraints
extension SignUpViewController4 {
    private func setupView() {
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .backgroundColor
        textView.font = .systemFont(ofSize: 28, weight: .heavy)
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.textAlignment = .center
        textView.keyboardType = .numberPad
        self.nextButton.alpha = 0.9
        self.nextButton.isEnabled = false

        textView.delegate = self
        setupConstraints()
    }

    private func setupConstraints() {
        removeTextField()
        view.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(70)
        }

        nextButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
    }
}

// MARK: - TextView configuring
extension SignUpViewController4: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentCharCount = textView.text?.count ?? 0
        if range.length + range.location > currentCharCount {
            return false
        }
        let newLength = currentCharCount + text.count - range.length
        return newLength <= 6
    }

    func textViewDidChange(_ textView: UITextView) {
        makeSymbolSpacing(text: textView.text)
        if textView.text.count == 6 {
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 1
                self.nextButton.isEnabled = true
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.nextButton.alpha = 0.9
                self.nextButton.isEnabled = false
            }
        }
    }

    func makeSymbolSpacing(text: String) {
        let letterSpacing: CGFloat = 1.5
        let text = textView.text ?? ""

        let attributes: [NSAttributedString.Key: Any] = [
            .kern: letterSpacing,
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)

        textView.attributedText = attributedText
        textView.textAlignment = .center
    }
}

// MARK: - Verification logic
extension SignUpViewController4 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        guard let code = textView.text else { return }
        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

        if let currentUser = Auth.auth().currentUser {
            currentUser.link(with: credential) { (result, error) in
                if let error = error {
                    self.alertView.showAlert(with: "Ooops... error!", message: error.localizedDescription, on: self)
                } else {
                    print("Accounts linked")
                    self.navigationController?.pushViewController(SignUpViewController5(), animated: true)
                }
            }
        }
    }

    @objc private func dismissAlertView() {
        alertView.dismissAlertView()
    }
}
