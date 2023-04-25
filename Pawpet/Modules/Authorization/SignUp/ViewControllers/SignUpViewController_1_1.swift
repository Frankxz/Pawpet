//
//  SignUpViewController_1_1.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController_1_1: BaseSignUpViewController {

    private let textView = UITextView()
    public var verificationID: String!
    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nextVC = SignUpViewController_2()
        promptView.setupTitles(title: "Enter the verification code.", subtitle: "The verification code has been sent to your phone number. It should come within 5 minutes. If you don't receive a verification code, please try again later.")
        setupAnimationView(with: "WatchingDog")
        setupView()

        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: UI + Constraints
extension SignUpViewController_1_1 {
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
extension SignUpViewController_1_1: UITextViewDelegate {
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
        let letterSpacing: CGFloat = 15
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
extension SignUpViewController_1_1 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        guard let code = textView.text else { return }
        let credentional =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

        Auth.auth().signIn(with: credentional) { (_, error) in
            if error != nil {
                let alertActionController = UIAlertController(title: error?.localizedDescription ?? "Unknown error", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertActionController.addAction(cancelAction)
                self.present(alertActionController, animated: true)
            } else {
                self.navigationController?.pushViewController(SignUpViewController_2(), animated: true)
            }
        }
    }
}
