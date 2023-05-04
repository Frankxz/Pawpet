//
//  PostViewController_6.swift
//  Pawpet
//
//  Created by Robert Miller on 12.04.2023.
//

import UIKit

class PostViewController_6: UIViewController {
    
    // MARK: - PromptView
    private var promptView = PromptView(with: "Enter a description",
                                        and: "If you do not want to specify anything in the description, you can skip this step.", titleSize: 32)

    // MARK: - Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK: - TextView
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.cornerRadius = 6
        textView.backgroundColor = .backgroundColor
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isScrollEnabled = true
        return textView
    }()

    var maxTextViewHeight: CGFloat = 260

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textView.delegate = self
        setupNavigationAppearence()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        addKeyBoardObserbers()
    }
}

// MARK: - UI + Constraints
extension PostViewController_6 {
    private func setupConstraints() {
        view.addSubview(promptView)
        view.addSubview(textView)
        view.addSubview(nextButton)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }

        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(260)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - Button logic
extension PostViewController_6 {
    @objc func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(PostViewController_7(), animated: true)
        }
        
        // TODO: PublicationManager
        PublicationManager.shared.currentPublication.petInfo.description = textView.text ?? ""
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            nextButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(keyboardHeight + 10)
                make.height.equalTo(70)
            }

            self.maxTextViewHeight = 260
            self.updateTextViewHeight()

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        nextButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(70)
        }

        self.maxTextViewHeight = 560
        self.updateTextViewHeight()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate
extension PostViewController_6: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
     }

    func updateTextViewHeight() {
        textView.snp.removeConstraints()
        textView.snp.makeConstraints { make in
            print(textView.frame.width)
            let estimatedSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
            print(estimatedSize.width)
            print(estimatedSize.height)
            let newHeight = min(estimatedSize.height, maxTextViewHeight)

            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(newHeight)
        }
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: KB Observers
extension PostViewController_6 {
    private func addKeyBoardObserbers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}
