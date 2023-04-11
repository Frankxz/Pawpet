//
//  PostViewController_6.swift
//  Pawpet
//
//  Created by Robert Miller on 12.04.2023.
//

import UIKit

class PostViewController_6: UIViewController {
    
    // MARK: - PromptView
    private var promptView = PromptView(with: "You can enter a description for your pet ",
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        textView.delegate = self
        setupConstraints()
    }
}

// MARK: - UI + Constraints
extension PostViewController_6 {
    private func setupConstraints() {
        view.addSubview(nextButton)
        view.addSubview(promptView)
        view.addSubview(textView)

        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(60)
        }

        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(promptView.snp.bottom).offset(20)
            make.height.equalTo(250)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}

// MARK: - Button logic
extension PostViewController_6 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.dismiss(animated: true) {
                // TODO: -
            }
        }
    }
}

// MARK: - TextView Logic
extension PostViewController_6: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width - 20, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if estimatedSize.height < 400 && estimatedSize.height > 250 {
            textView.snp.updateConstraints { make in
                make.height.equalTo(estimatedSize.height)
            }
        }
    }
}
