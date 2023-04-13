//
//  SignUpViewController_1.swift
//  Pawpet
//
//  Created by Robert Miller on 20.03.2023.
//

import UIKit
import Lottie

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

    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        promptView.setupTitles(title: "Enter your email", subtitle: "This will help us in the future to send you notifications, as well as in case of account recovery.")
        textField.setupPlaceholder(placeholder: "email@mail.com")
        setupAnimationView(with: "WatchingDog")
        setupCloseButton()
        nextVC = SignUpViewController_2()
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
